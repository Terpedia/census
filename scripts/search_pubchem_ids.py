#!/usr/bin/env python3
"""Resolve T# structures to PubChem CIDs by exact InChIKey lookup.

Input is the BigQuery-exported missing-ID CSV. Requests are batched and kept
below PubChem's documented five-requests-per-second limit. The output retains
unmatched records so coverage can be audited exactly.
"""

import argparse
import csv
import json
import time
import urllib.error
import urllib.parse
import urllib.request
from collections import defaultdict
from datetime import datetime, timezone

from rdkit import Chem, RDLogger
from rdkit.Chem import inchi

RDLogger.DisableLog("rdApp.*")
BASE = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchikey/{}/property/InChIKey/JSON"


def chunks(values, size):
    for offset in range(0, len(values), size):
        yield values[offset:offset + size]


def fetch(keys, retries=5):
    encoded = urllib.parse.quote(",".join(keys), safe=",-")
    request = urllib.request.Request(
        BASE.format(encoded),
        headers={"User-Agent": "Terpedia-census/1.0 (contact: info@terpedia.com)"},
    )
    for attempt in range(retries):
        try:
            with urllib.request.urlopen(request, timeout=60) as response:
                payload = json.load(response)
            result = defaultdict(list)
            for item in payload.get("PropertyTable", {}).get("Properties", []):
                result[item["InChIKey"]].append(str(item["CID"]))
            return result
        except urllib.error.HTTPError as exc:
            if exc.code == 404:
                return defaultdict(list)
            if exc.code not in (429, 500, 502, 503, 504) or attempt == retries - 1:
                raise
        except (TimeoutError, urllib.error.URLError):
            if attempt == retries - 1:
                raise
        time.sleep(2 ** attempt)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("input_csv")
    parser.add_argument("output_csv")
    parser.add_argument("--batch-size", type=int, default=100)
    parser.add_argument("--requests-per-second", type=float, default=4.0)
    parser.add_argument("--limit", type=int)
    args = parser.parse_args()

    with open(args.input_csv, newline="") as handle:
        rows = list(csv.DictReader(handle))
    if args.limit:
        rows = rows[:args.limit]

    for row in rows:
        key = (row.get("inchikey") or "").strip()
        if not key:
            mol = Chem.MolFromInchi(row["inchi"])
            key = inchi.MolToInchiKey(mol) if mol else ""
        row["resolved_inchikey"] = key

    unique_keys = sorted({row["resolved_inchikey"] for row in rows if row["resolved_inchikey"]})
    cid_map = defaultdict(list)
    delay = 1.0 / args.requests_per_second
    for index, batch in enumerate(chunks(unique_keys, args.batch_size), 1):
        started = time.monotonic()
        cid_map.update(fetch(batch))
        if index % 100 == 0:
            print(f"batches={index} keys={min(index * args.batch_size, len(unique_keys))} "
                  f"matched_keys={len(cid_map)}", flush=True)
        time.sleep(max(0, delay - (time.monotonic() - started)))

    retrieved_at = datetime.now(timezone.utc).isoformat()
    fields = [
        "terpene_id", "identity_set_key", "resolved_inchikey", "pubchem_cids",
        "pubchem_match_status", "mapping_method", "retrieved_at",
    ]
    with open(args.output_csv, "w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            key = row["resolved_inchikey"]
            cids = sorted(set(cid_map.get(key, [])), key=int)
            writer.writerow({
                "terpene_id": row["terpene_id"],
                "identity_set_key": row["identity_set_key"],
                "resolved_inchikey": key,
                "pubchem_cids": ";".join(cids),
                "pubchem_match_status": "matched" if cids else "not_found",
                "mapping_method": "pubchem_pug_rest_exact_inchikey",
                "retrieved_at": retrieved_at,
            })
    matched_rows = sum(bool(cid_map.get(row["resolved_inchikey"])) for row in rows)
    print(f"rows={len(rows)} unique_keys={len(unique_keys)} matched_rows={matched_rows} "
          f"unmatched_rows={len(rows) - matched_rows}")


if __name__ == "__main__":
    main()
