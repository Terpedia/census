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
| Exact PubChem identity coverage | Complete for current T# snapshot | Every T# requeried uniformly; `data/reports/pubchem-complete-lookup-20260904.json` |
| Identity-policy sensitivity | Complete for current T# snapshot | RDKit 2026.03.6 analysis in `data/reports/identity-sensitivity-20260904.json` |
| Per-T# chemical-class evidence | Complete for ChEBI 239 + MARTS frontier | Every T# is graded in `terpene_classification_evidence_20260904_v2`; 6,585 exact ChEBI matches and 54 direct MARTS products yield a 6,605-member A-or-B union |
| Classification error estimate | Missing | Preregister and execute stratified manual audit with confidence intervals |
| Cross-source completeness | Partial | Seven cross-reference sources mapped; named sources remain outside the union |
| Reaction/network coverage | Complete for current graph snapshot | `data/reports/marts-network-coverage-20260904.json` |
| MARTS enzyme and catalog-promiscuity census | Complete for ingested snapshot | Same report; source-version reconciliation remains a release-metadata task |
| Organism association census by evidence level | Partial | 72,930 COCONUT T# identities materialized as source-reported associations; measured, isolated, and biosynthesized tiers remain |
| Experimental versus predicted provenance census | Partial | 54 strict T# products have directly characterized MARTS reaction support; whole-corpus occurrence/isolation/measurement tiers remain |
| Purchasability | Partial | TeroKit snapshot counted; independent dated vendor verification absent |
| PubMed literature census | Partial | 6,500 retrieval records plus a deduplicated 1,850-pair function panel; unique terpene-positive and identity-linked PMID counts absent |
| PubChem BioAssay census | Complete for participation and active/inactive associations | 29,251 T# identities and 94,733 AIDs; inconclusive versus unspecified requires result-level retrieval |
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
