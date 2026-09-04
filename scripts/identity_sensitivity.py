#!/usr/bin/env python3
"""Measure how T# counts change under explicit chemical identity policies."""

import argparse
import csv
import json
from datetime import datetime, timezone
from pathlib import Path

from rdkit import Chem, RDLogger, rdBase
from rdkit.Chem import inchi
from rdkit.Chem.MolStandardize import rdMolStandardize

RDLogger.DisableLog("rdApp.*")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("input_csv", type=Path)
    parser.add_argument("output_json", type=Path)
    parser.add_argument(
        "--input-label",
        help="Stable source description to record instead of the local CSV path",
    )
    args = parser.parse_args()

    counts = {
        "rows": 0,
        "invalid_smiles": 0,
        "disconnected_input_rows": 0,
        "fluorinated_rows": 0,
    }
    values = {
        "rdkit_standard_inchi": set(),
        "rdkit_full_inchikey": set(),
        "connectivity_inchikey_block": set(),
        "canonical_isomeric_smiles": set(),
        "canonical_nonisomeric_smiles": set(),
        "fragment_parent_full_inchikey": set(),
        "fragment_parent_connectivity_block": set(),
    }

    with args.input_csv.open(newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle):
            counts["rows"] += 1
            smiles = row["smiles"]
            if "." in smiles:
                counts["disconnected_input_rows"] += 1
            mol = Chem.MolFromSmiles(smiles)
            if mol is None:
                counts["invalid_smiles"] += 1
                continue
            if any(atom.GetSymbol() == "F" for atom in mol.GetAtoms()):
                counts["fluorinated_rows"] += 1

            std_inchi = inchi.MolToInchi(mol)
            full_key = inchi.InchiToInchiKey(std_inchi)
            values["rdkit_standard_inchi"].add(std_inchi)
            values["rdkit_full_inchikey"].add(full_key)
            values["connectivity_inchikey_block"].add(full_key[:14])
            values["canonical_isomeric_smiles"].add(
                Chem.MolToSmiles(mol, canonical=True, isomericSmiles=True)
            )
            values["canonical_nonisomeric_smiles"].add(
                Chem.MolToSmiles(mol, canonical=True, isomericSmiles=False)
            )

            # FragmentParent is expensive and can only change a disconnected
            # input. Reuse the full key for single-component structures.
            if "." in smiles:
                parent = rdMolStandardize.FragmentParent(mol)
                parent_key = inchi.MolToInchiKey(parent)
            else:
                parent_key = full_key
            values["fragment_parent_full_inchikey"].add(parent_key)
            values["fragment_parent_connectivity_block"].add(parent_key[:14])

    result = {
        "computed_at_utc": datetime.now(timezone.utc).isoformat(),
        "rdkit_version": rdBase.rdkitVersion,
        "input": args.input_label or str(args.input_csv),
        **counts,
        "distinct_counts": {key: len(value) for key, value in values.items()},
        "policy_boundary": (
            "These are identity-policy sensitivity counts, not terpene-class "
            "validation. FragmentParent applies RDKit's standard fragment-parent "
            "operation; connectivity blocks discard stereochemical and protonation "
            "layers."
        ),
    }
    args.output_json.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
