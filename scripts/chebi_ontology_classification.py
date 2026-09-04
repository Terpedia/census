#!/usr/bin/env python3
"""Extract ChEBI terpene/terpenoid descendants from a release OWL snapshot.

The script deliberately uses only asserted ``rdfs:subClassOf`` links whose
object is a named ChEBI class.  Restrictions and inferred axioms are not
treated as subclass edges.  It emits one JSONL record per non-obsolete
chemical class in either boundary, suitable for loading into BigQuery and
joining to the T# registry by full InChIKey or connectivity block.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import defaultdict, deque
from pathlib import Path
from xml.etree import ElementTree as ET


RDF = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
RDFS = "http://www.w3.org/2000/01/rdf-schema#"
OWL = "http://www.w3.org/2002/07/owl#"
OBO = "http://purl.obolibrary.org/obo/"
CHEBI = "http://purl.obolibrary.org/obo/chebi/"
OBO_IN_OWL = "http://www.geneontology.org/formats/oboInOwl#"

ABOUT = f"{{{RDF}}}about"
RESOURCE = f"{{{RDF}}}resource"
CLASS = f"{{{OWL}}}Class"
SUBCLASS = f"{{{RDFS}}}subClassOf"
LABEL = f"{{{RDFS}}}label"
DEPRECATED = f"{{{OWL}}}deprecated"
INCHI = f"{{{CHEBI}}}inchi"
INCHIKEY = f"{{{CHEBI}}}inchikey"
SMILES = f"{{{CHEBI}}}smiles"
FORMULA = f"{{{CHEBI}}}formula"
VERSION_IRI = f"{{{OWL}}}versionIRI"
COMMENT = f"{{{RDFS}}}comment"

TERPENE = "35186"
TERPENOID = "26873"


def chebi_id(uri: str | None) -> str | None:
    prefix = f"{OBO}CHEBI_"
    return uri[len(prefix) :] if uri and uri.startswith(prefix) else None


def descendants(children: dict[str, set[str]], root: str) -> set[str]:
    found = {root}
    queue = deque([root])
    while queue:
        parent = queue.popleft()
        for child in children.get(parent, ()):
            if child not in found:
                found.add(child)
                queue.append(child)
    return found


def parse_owl(path: Path) -> tuple[dict[str, dict], dict[str, set[str]], dict]:
    records: dict[str, dict] = {}
    children: dict[str, set[str]] = defaultdict(set)
    metadata: dict[str, str] = {}

    for _event, element in ET.iterparse(path, events=("end",)):
        if element.tag == f"{{{OWL}}}Ontology":
            version = element.find(VERSION_IRI)
            if version is not None:
                metadata["version_iri"] = version.attrib.get(RESOURCE, "")
            comments = [node.text or "" for node in element.findall(COMMENT)]
            metadata["comments"] = comments
            element.clear()
            continue

        if element.tag != CLASS:
            continue

        identifier = chebi_id(element.attrib.get(ABOUT))
        if identifier is None:
            element.clear()
            continue

        parents: set[str] = set()
        for node in element.findall(SUBCLASS):
            parent = chebi_id(node.attrib.get(RESOURCE))
            if parent:
                parents.add(parent)
                children[parent].add(identifier)

        def value(tag: str) -> str | None:
            node = element.find(tag)
            return node.text if node is not None else None

        records[identifier] = {
            "chebi_id": f"CHEBI:{identifier}",
            "label": value(LABEL),
            "inchi": value(INCHI),
            "inchikey": value(INCHIKEY),
            "smiles": value(SMILES),
            "formula": value(FORMULA),
            "deprecated": (value(DEPRECATED) or "false").lower() == "true",
            "asserted_parent_ids": sorted(f"CHEBI:{p}" for p in parents),
        }
        element.clear()

    return records, children, metadata


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("owl", type=Path)
    parser.add_argument("output_jsonl", type=Path)
    parser.add_argument("--report", type=Path)
    parser.add_argument("--source-uri")
    args = parser.parse_args()

    records, children, metadata = parse_owl(args.owl)
    terpene = descendants(children, TERPENE)
    terpenoid = descendants(children, TERPENOID)
    combined = terpene | terpenoid

    output_rows = []
    for identifier in sorted(combined, key=int):
        record = records.get(identifier)
        if not record or record["deprecated"]:
            continue
        record = dict(record)
        record["is_terpene_descendant"] = identifier in terpene
        record["is_terpenoid_descendant"] = identifier in terpenoid
        record["ontology_boundary"] = (
            "both"
            if identifier in terpene and identifier in terpenoid
            else "terpene"
            if identifier in terpene
            else "terpenoid"
        )
        output_rows.append(record)

    args.output_jsonl.parent.mkdir(parents=True, exist_ok=True)
    with args.output_jsonl.open("w", encoding="utf-8") as handle:
        for row in output_rows:
            handle.write(json.dumps(row, sort_keys=True) + "\n")

    digest = hashlib.sha256()
    with args.owl.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)

    report = {
        "source_file": str(args.owl),
        "source_uri": args.source_uri,
        "source_size_bytes": args.owl.stat().st_size,
        "source_sha256": digest.hexdigest(),
        "ontology_metadata": metadata,
        "method": "transitive closure over asserted named rdfs:subClassOf edges",
        "roots": {
            "terpene": "CHEBI:35186",
            "terpenoid": "CHEBI:26873",
        },
        "all_class_records": len(records),
        "nonobsolete_output_records": len(output_rows),
        "terpene_descendants_including_root": sum(
            not records[i]["deprecated"] for i in terpene if i in records
        ),
        "terpenoid_descendants_including_root": sum(
            not records[i]["deprecated"] for i in terpenoid if i in records
        ),
        "combined_descendants_including_roots": len(output_rows),
        "output_with_inchikey": sum(bool(row["inchikey"]) for row in output_rows),
        "output_with_inchi": sum(bool(row["inchi"]) for row in output_rows),
    }
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
