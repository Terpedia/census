#!/usr/bin/env python3
"""Count PubChem BioAssay participation for an exact T# to CID mapping."""

import argparse
import csv
import json
import sqlite3
import threading
import time
import urllib.error
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone


BASE = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/aids/JSON"


class RateLimiter:
    def __init__(self, requests_per_second):
        self.interval = 1.0 / requests_per_second
        self.lock = threading.Lock()
        self.next_start = 0.0

    def wait(self):
        with self.lock:
            now = time.monotonic()
            delay = max(0.0, self.next_start - now)
            if delay:
                time.sleep(delay)
            self.next_start = time.monotonic() + self.interval


def chunks(values, size):
    for offset in range(0, len(values), size):
        yield values[offset:offset + size]


def fetch(batch, limiter, aids_type, retries=5):
    body = urllib.parse.urlencode({"cid": ",".join(batch)}).encode()
    for attempt in range(retries):
        limiter.wait()
        request = urllib.request.Request(
            f"{BASE}?aids_type={aids_type}",
            data=body,
            headers={"User-Agent": "Terpedia-census/1.0 (contact: info@terpedia.com)"},
        )
        try:
            with urllib.request.urlopen(request, timeout=120) as response:
                payload = json.load(response)
            result = {cid: [] for cid in batch}
            for item in payload.get("InformationList", {}).get("Information", []):
                result[str(item["CID"])] = [str(aid) for aid in item.get("AID", [])]
            return result
        except urllib.error.HTTPError as exc:
            if exc.code == 404:
                return {cid: [] for cid in batch}
            if exc.code not in (429, 500, 502, 503, 504) or attempt == retries - 1:
                raise
        except (TimeoutError, urllib.error.URLError):
            if attempt == retries - 1:
                raise
        time.sleep(2 ** attempt)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("mapping_csv")
    parser.add_argument("cid_output_csv")
    parser.add_argument("report_json")
    parser.add_argument("--batch-size", type=int, default=500)
    parser.add_argument("--workers", type=int, default=3)
    parser.add_argument("--requests-per-second", type=float, default=4.0)
    parser.add_argument("--aids-type", choices=("all", "active", "inactive"), default="all")
    parser.add_argument("--limit-cids", type=int)
    parser.add_argument(
        "--mapping-label",
        help="Stable source-table label to record instead of the local CSV path",
    )
    parser.add_argument(
        "--cache-db",
        help="Resume-safe SQLite cache (default: CID output path plus .sqlite)",
    )
    args = parser.parse_args()

    t_to_cids = {}
    with open(args.mapping_csv, newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle):
            t_to_cids[row["terpene_id"]] = tuple(
                cid for cid in row["pubchem_cids"].split(";") if cid
            )
    cids = sorted({cid for group in t_to_cids.values() for cid in group}, key=int)
    if args.limit_cids:
        cids = cids[:args.limit_cids]

    cache_path = args.cache_db or f"{args.cid_output_csv}.sqlite"
    connection = sqlite3.connect(cache_path)
    connection.execute(
        "CREATE TABLE IF NOT EXISTS cid_aids "
        "(pubchem_cid TEXT PRIMARY KEY, pubchem_aids TEXT NOT NULL)"
    )
    connection.execute(
        "CREATE TABLE IF NOT EXISTS metadata "
        "(key TEXT PRIMARY KEY, value TEXT NOT NULL)"
    )
    cached_type = connection.execute(
        "SELECT value FROM metadata WHERE key = 'aids_type'"
    ).fetchone()
    if cached_type and cached_type[0] != args.aids_type:
        raise ValueError(
            f"cache contains aids_type={cached_type[0]!r}, requested {args.aids_type!r}"
        )
    connection.execute(
        "INSERT OR REPLACE INTO metadata(key, value) VALUES ('aids_type', ?)",
        (args.aids_type,),
    )
    connection.commit()
    existing = {row[0] for row in connection.execute("SELECT pubchem_cid FROM cid_aids")}
    pending_cids = [cid for cid in cids if cid not in existing]

    limiter = RateLimiter(args.requests_per_second)
    batches = list(chunks(pending_cids, args.batch_size))
    failures = []
    with ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = {
            executor.submit(fetch, batch, limiter, args.aids_type): batch
            for batch in batches
        }
        for index, future in enumerate(as_completed(futures), 1):
            try:
                result = future.result()
            except Exception as exc:  # Persist successful batches before failing.
                failures.append((futures[future], repr(exc)))
                print(f"failed_batch={futures[future][0]} error={exc!r}", flush=True)
                continue
            connection.executemany(
                "INSERT OR REPLACE INTO cid_aids(pubchem_cid, pubchem_aids) VALUES (?, ?)",
                (
                    (cid, ";".join(sorted(set(aids), key=int)))
                    for cid, aids in result.items()
                ),
            )
            connection.commit()
            if index % 50 == 0:
                completed = connection.execute("SELECT COUNT(*) FROM cid_aids").fetchone()[0]
                with_aids = connection.execute(
                    "SELECT COUNT(*) FROM cid_aids WHERE pubchem_aids != ''"
                ).fetchone()[0]
                print(
                    f"batches={index}/{len(batches)} cached_cids={completed} "
                    f"with_aids={with_aids}",
                    flush=True,
                )
    if failures:
        connection.close()
        raise RuntimeError(
            f"{len(failures)} batches failed; rerun with the same --cache-db to resume"
        )

    queried = set(cids)
    cid_to_aids = {
        cid: aids.split(";") if aids else []
        for cid, aids in connection.execute(
            "SELECT pubchem_cid, pubchem_aids FROM cid_aids"
        )
        if cid in queried
    }
    connection.close()

    retrieved_at = datetime.now(timezone.utc).isoformat()
    all_aids = set()
    with open(args.cid_output_csv, "w", newline="", encoding="utf-8") as handle:
        fields = ["pubchem_cid", "pubchem_aids", "bioassay_count", "retrieved_at"]
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        for cid in cids:
            aids = sorted(set(cid_to_aids.get(cid, [])), key=int)
            all_aids.update(aids)
            writer.writerow(
                {
                    "pubchem_cid": cid,
                    "pubchem_aids": ";".join(aids),
                    "bioassay_count": len(aids),
                    "retrieved_at": retrieved_at,
                }
            )

    t_with_aids = sum(
        any(cid_to_aids.get(cid) for cid in mapped_cids if cid in queried)
        for mapped_cids in t_to_cids.values()
    )
    if args.aids_type == "all":
        scope_boundary = (
            "Participation means that PubChem associates at least one AID with an "
            "exactly mapped CID. It does not imply an active result, a unique "
            "biological target, or that PubChem classifies the compound as a terpene."
        )
    else:
        scope_boundary = (
            f"{args.aids_type.capitalize()} means PubChem returns the AID for the "
            f"mapped CID under aids_type={args.aids_type}. It is a database outcome "
            "association, not proof of efficacy, safety, a unique target, or terpene "
            "classification."
        )
    result = {
        "retrieved_at_utc": retrieved_at,
        "method": "PubChem PUG REST grouped CID-to-AID lookup",
        "aids_type": args.aids_type,
        "mapping_input": args.mapping_label or args.mapping_csv,
        "total_t_ids": len(t_to_cids),
        "t_ids_with_pubchem_cid": sum(bool(group) for group in t_to_cids.values()),
        "distinct_cids_queried": len(cids),
        "cids_with_bioassays": sum(bool(cid_to_aids.get(cid)) for cid in cids),
        "t_ids_with_bioassays": t_with_aids,
        "distinct_bioassays_testing_t_ids": len(all_aids),
        "cid_aid_links": sum(len(set(cid_to_aids.get(cid, []))) for cid in cids),
        "scope_boundary": scope_boundary,
    }
    with open(args.report_json, "w", encoding="utf-8") as handle:
        json.dump(result, handle, indent=2)
        handle.write("\n")
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
