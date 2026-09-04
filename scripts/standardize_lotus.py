#!/usr/bin/env python3
"""Standardize the immutable LOTUS structure snapshot for census joins.

LOTUS membership is natural-product source evidence, not terpene-class
evidence. The emitted identifiers support exact and connectivity joins; they
do not assign T numbers or chemical evidence tiers by themselves.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

import rdkit
from rdkit import Chem, RDLogger
from rdkit.Chem import rdMolDescriptors
from rdkit.Chem.MolStandardize import rdMolStandardize


RDLogger.DisableLog("rdApp.*")


def standardize(record: tuple[int, str, str]) -> dict:
    source_row, smiles, lotus_id = record
    result = {
        "source_row": source_row,
        "lotus_id": lotus_id,
        "source_smiles": smiles,
        "parse_status": "invalid",
    }
    mol = Chem.MolFromSmiles(smiles)
    if mol is None:
        return result
    result.update(
        {
            "parse_status": "valid",
            "canonical_isomeric_smiles": Chem.MolToSmiles(
                mol, canonical=True, isomericSmiles=True
            ),
            "standard_inchi": Chem.MolToInchi(mol),
            "full_inchikey": Chem.MolToInchiKey(mol),
            "molecular_formula": rdMolDescriptors.CalcMolFormula(mol),
            "carbon_count": sum(atom.GetAtomicNum() == 6 for atom in mol.GetAtoms()),
            "disconnected": len(Chem.GetMolFrags(mol)) > 1,
        }
    )
    try:
        parent = rdMolStandardize.FragmentParent(mol)
        parent = rdMolStandardize.Uncharger().uncharge(parent)
        Chem.SanitizeMol(parent)
    except Exception:
        parent = mol
    parent_key = Chem.MolToInchiKey(parent)
    result.update(
        {
            "parent_isomeric_smiles": Chem.MolToSmiles(
                parent, canonical=True, isomericSmiles=True
            ),
            "parent_inchikey": parent_key,
            "parent_connectivity": parent_key.split("-")[0] if parent_key else None,
        }
    )
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_tsv", type=Path)
    parser.add_argument("output_jsonl", type=Path)
    parser.add_argument("--report", type=Path)
    parser.add_argument("--source-uri")
    parser.add_argument("--workers", type=int, default=4)
    args = parser.parse_args()

    digest = hashlib.sha256()
    with args.input_tsv.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)

    records = []
    with args.input_tsv.open(encoding="utf-8", newline="") as handle:
        for row_number, row in enumerate(csv.reader(handle, delimiter="\t"), start=1):
            if len(row) != 2:
                records.append((row_number, "", f"MALFORMED_ROW_{row_number}"))
            else:
                records.append((row_number, row[0], row[1]))

    counts: Counter[str] = Counter()
    valid_keys: set[str] = set()
    valid_smiles: set[str] = set()
    unique_lotus_ids: set[str] = set()
    args.output_jsonl.parent.mkdir(parents=True, exist_ok=True)
    with args.output_jsonl.open("w", encoding="utf-8") as output:
        with ThreadPoolExecutor(max_workers=args.workers) as pool:
            for result in pool.map(standardize, records, chunksize=200):
                output.write(json.dumps(result, sort_keys=True) + "\n")
                counts[result["parse_status"]] += 1
                unique_lotus_ids.add(result["lotus_id"])
                if result["parse_status"] == "valid":
                    valid_keys.add(result["full_inchikey"])
                    valid_smiles.add(result["canonical_isomeric_smiles"])
                    counts["disconnected"] += bool(result["disconnected"])

    report = {
        "source_file": str(args.input_tsv),
        "source_uri": args.source_uri,
        "source_size_bytes": args.input_tsv.stat().st_size,
        "source_sha256": digest.hexdigest(),
        "rdkit_version": rdkit.__version__,
        "source_rows": len(records),
        "unique_lotus_ids": len(unique_lotus_ids),
        "valid_structures": counts["valid"],
        "invalid_structures": counts["invalid"],
        "disconnected_structures": counts["disconnected"],
        "distinct_full_inchikeys": len(valid_keys),
        "distinct_canonical_isomeric_smiles": len(valid_smiles),
        "interpretation": (
            "Identity normalization only; LOTUS membership does not establish "
            "terpene or terpenoid chemical-class membership."
        ),
    }
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
