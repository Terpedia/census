# How many terpenes are there?

This repository develops a short, source-audited paper about the apparently simple question: **how many terpenes are there?**

The first web search suggests that there is no single stable answer. Published and educational sources use several nearby numbers—more than 20,000, more than 30,000, about 55,000, and a database count of 59,833—while often using *terpene* and *terpenoid* interchangeably. The paper will treat the number as a claim whose scope, definition, date, and counting method must be reported.

## Contents

- [`paper.md`](paper.md) — working paper draft
- [`sources.md`](sources.md) — source ledger and search notes
- [`queries.sql`](queries.sql) — BigQuery inventory, count, and overlap queries

The materialized identity table is
`terpedia-489015.terpedia_core.terpene_identity_set`. Its `T#` value is a
snapshot-stable curation handle with a carbon-count prefix (`T10`, `T15`,
`T20`, `T25`, `T30`, `T40`, or `TXX`); `source_crossrefs` is the exact-key,
provenance-preserving cross-reference array. The old-to-new mapping is in
`terpedia-489015.terpedia_core.terpene_id_crosswalk_20260904`, and the
pre-remap snapshot is retained as
`terpedia-489015.terpedia_core.terpene_identity_set_pre_remap_20260904`.
The structure-based display order is in
`terpedia-489015.terpedia_core.terpene_similarity_order_20260904`; it groups
exact Bemis–Murcko scaffolds and uses Morgan-2048 fingerprint hashes only for
deterministic tie-breaking.
The exact-InChIKey PubChem recovery audit is in
`terpedia-489015.terpedia_core.terpene_pubchem_lookup_20260904` and can be
reproduced with [`scripts/search_pubchem_ids.py`](scripts/search_pubchem_ids.py).
The aggregate RDKit Rule-of-Five census is recorded in
[`data/reports/lipinski-20260904.json`](data/reports/lipinski-20260904.json).

## Research question

When a source says “there are N terpenes,” what exactly is being counted?

The project will separate at least four quantities:

1. strict terpene hydrocarbons;
2. terpenoids, including oxygenated and otherwise modified derivatives;
3. distinct chemical structures versus database records, stereoisomers, or synonyms; and
4. all known natural products versus compounds reported from a taxon, tissue, extract, or analytical method.

## Status

Initial repository and literature-search scaffold created 2026-09-03. The estimates in the draft are leads for verification, not a final census. The current data-census work is scoped to Terpedia BigQuery and RDF, following the upload-first Colab pattern in `chat/strain`.
