#!/usr/bin/env python3
"""Build a reproducible structure-similarity ordering for the T# set.

The primary grouping is the exact Bemis-Murcko scaffold. Morgan fingerprints
are used only as a deterministic tie-breaker within scaffold groups; this is a
scaffold-family ordering, not a claim that adjacent rows have a measured
Tanimoto similarity.
"""

import argparse
import csv
import hashlib
import multiprocessing as mp
from collections import Counter

from rdkit import Chem, RDLogger
from rdkit.Chem import AllChem, DataStructs
from rdkit.Chem.Scaffolds import MurckoScaffold

RDLogger.DisableLog("rdApp.*")


def parse_row(row):
    mol = Chem.MolFromSmiles(row["smiles"])
    if mol is None:
        return {**row, "canonical_smiles": None, "scaffold_smiles": None,
                "scaffold_hash": None, "fingerprint_hash": None,
                "structure_status": "invalid_smiles"}
    canonical = Chem.MolToSmiles(mol, canonical=True)
    scaffold = Chem.MolToSmiles(MurckoScaffold.GetScaffoldForMol(mol), canonical=True)
    fp = AllChem.GetMorganFingerprintAsBitVect(mol, radius=2, nBits=2048)
    fp_bits = DataStructs.BitVectToText(fp)
    return {**row, "canonical_smiles": canonical, "scaffold_smiles": scaffold,
            "scaffold_hash": hashlib.sha256(scaffold.encode()).hexdigest(),
            "fingerprint_hash": hashlib.sha256(fp_bits.encode()).hexdigest(),
            "structure_status": "valid"}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("input_csv")
    ap.add_argument("output_csv")
    ap.add_argument("--workers", type=int, default=max(1, mp.cpu_count() - 1))
    args = ap.parse_args()

    with open(args.input_csv, newline="") as handle:
        rows = list(csv.DictReader(handle))
    with mp.Pool(args.workers) as pool:
        parsed = list(pool.imap(parse_row, rows, chunksize=256))

    scaffold_counts = Counter(
        row["scaffold_hash"] for row in parsed if row["scaffold_hash"] is not None
    )
    parsed.sort(key=lambda row: (
        row["structure_status"] != "valid",
        -(scaffold_counts.get(row["scaffold_hash"], 0)),
        row["scaffold_hash"] or "",
        row["fingerprint_hash"] or "",
        row["identity_set_key"],
    ))
    fields = [
        "similarity_rank", "terpene_id", "identity_set_key", "smiles",
        "canonical_smiles", "scaffold_smiles", "scaffold_hash",
        "fingerprint_hash", "structure_status", "similarity_method",
    ]
    with open(args.output_csv, "w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        for rank, row in enumerate(parsed, 1):
            writer.writerow({
                "similarity_rank": rank,
                "terpene_id": row["terpene_id"],
                "identity_set_key": row["identity_set_key"],
                "smiles": row["smiles"],
                "canonical_smiles": row["canonical_smiles"],
                "scaffold_smiles": row["scaffold_smiles"],
                "scaffold_hash": row["scaffold_hash"],
                "fingerprint_hash": row["fingerprint_hash"],
                "structure_status": row["structure_status"],
                "similarity_method": "murcko_scaffold_v1_morgan2048_tiebreak",
            })
    print(f"rows={len(parsed)} valid={sum(r['structure_status'] == 'valid' for r in parsed)} "
          f"scaffolds={len(scaffold_counts)}")


if __name__ == "__main__":
    main()
