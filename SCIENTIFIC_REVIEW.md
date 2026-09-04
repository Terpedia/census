# Scientific review gate

This checklist defines the evidence required before `paper.md` can claim a
publication-grade census. A checked item must point to an executable query,
versioned result artifact, or manuscript section; prose intent alone is not
evidence.

| Requirement | Status | Current evidence or remaining gate |
|---|---|---|
| Separate source records, candidate identities, and validated identities | Complete | Three-tier framework in paper section 5 |
| Prevent identity identifiers from confirming terpene class | Complete | Corrected classification template in `queries.sql` |
| COCONUT–TeroKit candidate union | Complete | `data/reports/coconut-terokit-union-20260903.json` |
| Exact PubChem identity coverage | Partial | Recovery audit exists; imported CIDs still require structure revalidation |
| Identity-policy sensitivity | Complete for current T# snapshot | RDKit 2026.03.6 analysis in `data/reports/identity-sensitivity-20260904.json` |
| Per-T# chemical-class evidence | Partial | Source evidence exists; whole-corpus QC exposed fluorinated and disconnected-structure review strata |
| Classification error estimate | Missing | Preregister and execute stratified manual audit with confidence intervals |
| Cross-source completeness | Partial | Seven cross-reference sources mapped; named sources remain outside the union |
| Reaction/network coverage | Complete for current graph snapshot | `data/reports/marts-network-coverage-20260904.json` |
| MARTS enzyme and catalog-promiscuity census | Complete for ingested snapshot | Same report; source-version reconciliation remains a release-metadata task |
| Organism association census by evidence level | Missing | Design specified in paper section 10; counts not materialized |
| Experimental versus predicted provenance census | Missing | Evidence distinctions defined; per-T# aggregation not materialized |
| Purchasability | Partial | TeroKit snapshot counted; independent dated vendor verification absent |
| PubMed literature census | Partial | 6,500 retrieval records; terpene-positive and identity-linked counts absent |
| PubChem BioAssay census | Missing | Raw mirror exists; queryable T#–CID–AID result absent |
| Lipinski profile | Complete for current T# snapshot | `data/reports/lipinski-20260904.json` |
| Primary historical citation lineage | Partial | Several primary sources located; slide-derived claims remain unresolved |
| Immutable release manifest and software versions | Missing | Reports are dated but do not yet pin every input checksum/tool version |
| Internal terminology and identifier consistency | Partial | Known T# and scope contradictions corrected; full editorial audit remains |
| Final independent critical review | Missing | Run only after every required result is present |

## Current publication boundary

The manuscript may report **268,924 candidate terpene/terpenoid identities in
the stated two-source snapshot**. It may not report that number as verified
terpenes, as the complete Terpedia total, or as the number of terpenes known to
science.
