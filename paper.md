# How many terpenes are there?

*Working draft — 2026-09-03*

## Abstract

The question “how many terpenes are there?” appears to invite a number, but the literature supplies a moving family of numbers. A 2007 review described more than 30,000 plant terpenoids; a 2020 review repeated a figure of more than 20,000 terpenes in nature; a 2020 thesis distinguished about 8,000 terpenes from 30,000 terpenoids; and a 2023 data-science study assembled 59,833 terpene records from a natural-products database. These statements are not necessarily contradictory. They count different chemical universes under definitions that are often left implicit. This paper will reconstruct the history of the estimates, identify the provenance of their round numbers, and propose a reproducible way to answer “how many” at a stated date and scope.

## 1. The short answer

There is no defensible single number without a counting rule. A careful provisional answer is:

> **At least tens of thousands of naturally occurring terpene/terpenoid structures have been reported; the exact total depends on whether the count includes terpenoids, stereoisomers, conjugates, polymers, synonyms, and database-only records.**

The commonly repeated “55,000” figure should therefore be presented as an estimate for the broad terpene/terpenoid universe, not as a precise count of strict terpene hydrocarbons.

## 2. Why the number is unstable

In strict chemical usage, terpenes are hydrocarbons formally assembled from isoprene units, while terpenoids include oxygenated or otherwise modified compounds. In practice, reviews and public-facing sources frequently use *terpenes* as a short name for the larger terpenoid class. A count can also change when a source:

- merges or separates stereoisomers;
- treats a glycoside, ester, or rearranged skeleton as a new compound;
- counts named structures, reported occurrences, or database entries;
- includes compounds from animals, fungi, and microbes as well as plants; or
- adds newly reported structures without deduplicating historical names.

## 3. Historical estimate trail

| Date / source | Wording or count | Apparent scope | Confidence / next check |
|---|---:|---|---|
| TerpID slide 2, date not shown | 10,000 known terpenes | Flowers, plants, fruits | Exact source is a Google search link; identify the underlying Eybna Technologies page. |
| TerpID slide 2, date not shown | 20,000 known varieties | Plant natural compounds | Exact source is a Google search link; likely popular/educational wording. |
| TerpID slide 2, date not shown | 30,000 known terpenes; 400 in cannabis | Broad; cannabis subset | Exact source is a Google search link; verify whether “terpenes” means terpenoids. |
| TerpID slide 2, date not shown | >40,000 structures | Plant terpenoids/isoprenoids | Slide links to a PubMed search result; identify the underlying article. |
| TerpID slide 2, date not shown | >50,000 unique terpenes; ~250 in cannabis | Broad; cannabis subset | Exact source is a Google search link; verify date and definition. |
| TerpID slide 2, date not shown | >60,000 terpenoid structures | Natural sources | Exact source is a Google search link; likely an overview/reference page. |
| TerpID slide 2, date not shown | >70,000 terpenoids; >400 structural families | Dictionary of Natural Products | Exact source is a Google search link; retrieve the cited DNP context. |
| TerpID slide 2, date not shown | >80,000 known compounds | Terpenes / natural products | Exact source is a Google search link; identify the PMC article. |
| TerpID slide 2, date not shown | >90,000 known compounds | Terpenoids / natural products | Exact source is a Google search link; identify the PMC article. |
| TerpID slide 2, date not shown | Up to 100,000 | Projection including undiscovered plants | Explicit extrapolation, not an observed count. |
| 1989, as later cited in reference material | 55,000 chemical entities | Terpenes + terpenoids | Trace the original Dev book and page before treating this as a primary historical observation. |
| 2007, Han et al. | “more than 30,000 compounds” | Plant terpenoids | Peer-reviewed abstract; verify the cited underlying estimate and whether the translation uses terpene/terpenoid broadly. |
| 2015, Degenhardt/Gershenzon lineage as quoted in a thesis | >20,000 characterized unique compounds | Plant terpenes | Secondary quotation; retrieve the original chapter/review. |
| 2020, Andre et al. | >20,000 terpenes in nature; about 200 in cannabis | Nature broadly; cannabis subset | Peer-reviewed review; inspect references 142–144 and terminology. |
| 2020, Sukakul thesis | ~8,000 terpenes and ~30,000 terpenoids | Strict/broad distinction | Useful explicit distinction; verify cited reference 67. |
| 2023, Teoh et al. | 59,833 terpene records | COCONUT-derived computational dataset | A database inclusion count, not necessarily a count of unique in-vivo natural structures. |

This table is deliberately a history of claims, not a merged total.

## 4. Working thesis

The history of “how many” is probably a history of boundary changes as much as discovery. The apparent growth from roughly 20–30 thousand to roughly 55–60 thousand may reflect a mixture of:

1. genuine discovery of new natural products;
2. inclusion of additional organismal kingdoms and compound subclasses;
3. improved analytical and structure-elucidation methods; and
4. database expansion, synonym handling, and counting conventions.

The paper should not infer a discovery rate from the published headline numbers until those effects are separated.

## 5. Proposed reproducible answer

For a future release, report a count as a tuple rather than a naked integer:

`N = (definition, source universe, structure identity rule, date, database/version)`

For example: “59,833 records classified as terpenes in dataset X, version Y, downloaded on date Z; records are not asserted to equal unique natural terpene structures.”

## 6. Next work

- Resolve every Google search hyperlink on the TerpID slide to its underlying source; record title, author, date, and page/section.
- Retrieve the original references behind the 20,000, 30,000, and 55,000 estimates.
- Build a claim-level bibliography with publication date, exact quotation, page, and cited predecessor.
- Compare strict terpene and broad terpenoid counts using a fixed chemical-identity policy.
- Reproduce the 59,833-record dataset count if the underlying COCONUT release is available.
- Add a figure showing estimates as labeled claims, with scope encoded separately from year.

## 7. Terpedia data census: BigQuery and RDF

The operational question is different from the historical question: **how many terpene/terpenoid identities does Terpedia currently hold, and how much overlap exists among its sources?** The answer must be computed from source snapshots, not inferred by adding table row counts.

The first confirmed BigQuery inventory gives these raw row counts:

| BigQuery source | Raw rows | Counting role |
|---|---:|---|
| `coconut_complete` | 695,133 | Broad COCONUT source table |
| `coconut_terpenoids` | 199,405 | Terpenoid subset; do not add to `coconut_complete` |
| `coconut_terpenoids_pubchem` | 177,449 | Derived/linked subset; do not add to COCONUT totals |
| `terokit_molecules` | 337,904 | Molecule table |
| `terokit_purchasable_molecules` | 165,736 | Vendor relation/catalog; not an independent molecule universe |
| `terokit_reaction_molecules` | 9,584 | Reaction relation; not an independent molecule universe |
| `terokit_reaction_enzymes` | 27,974 | Enzyme relation; not a molecule count |

These are row counts, not the Terpedia total. The current defensible total is therefore **not yet a single integer** until BigQuery and RDF are joined on chemical identity. The primary deduplication key is `standard_inchi_key`/InChIKey; if absent, use a validated canonical-structure hash. Names and labels are discovery fields only and cannot establish identity.

### 7.1 Reaction-product coverage proxy

TeroKit provides a useful network-completeness proxy because its reaction
table distinguishes `substrate_ids` from `product_id`. In the local TeroKit
V2.5 file there are 4,792 reaction rows and 3,500 distinct product IDs. The
cloud table currently contains 9,584 rows because two source releases are
represented; these rows must be release-deduplicated before reporting a
network total.

The relevant quantity is not the number of reaction rows. It is the number of
distinct product-side chemical identities that are also classified as
terpenes/terpenoids. The reproducible query in `queries.sql` reports both the
source-ID count and the stronger structure-identity count, separating:

- distinct reaction products;
- products classified as source-declared terpenoids;
- products not yet confirmed as terpenoids; and
- ambiguous product identities.

Until that join is executed, **3,500 is the observed local product-ID
universe, not the number of terpene products**. A product-side reaction edge
also indicates a modeled biochemical transformation, not proof that the
reaction occurs in a particular organism in vivo.

The final report should publish at least three totals:

1. source-row counts;
2. unique chemical identities in each source; and
3. the union of unique identities across the selected molecule sources, with pairwise and multiway overlap.

The Colab notebook is read-only with respect to BigQuery. It should run the queries in [`queries.sql`](queries.sql), save result tables and the exact query timestamp, and never print or store the API key.

## 8. Terpenes mentioned in PubMed literature

Terpedia has a separate literature quantity: compounds named in PubMed-indexed records. This is not the same as the number of chemical identities in BigQuery or RDF. A paper can mention a terpene class without naming a molecule, and one molecule can appear under many spelling, stereochemical, and synonym forms.

The existing Terpedia literature snapshot is `terport/ttl/pubmed_terpenes.ttl`, generated by [`terport/src/update_from_pubmed.py`](../terport/src/update_from_pubmed.py). In the current local snapshot, it contains **6,500 distinct PMID identifiers / journal-article records**. This is a retrieval-snapshot count, not yet a validated count of terpene-positive articles. The companion `terpmed/public/results.json` contains a targeted PubMed query panel with **25 queried compound labels** and per-label hit counts; those labels are a search panel, not a census of all terpene names in PubMed.

The paper should report literature coverage at three levels:

1. **article mentions:** distinct PubMed IDs whose title, abstract, or indexed fields matched the retrieval query;
2. **name mentions:** distinct normalized terpene/terpenoid labels extracted from article text or query panels; and
3. **identity-linked mentions:** distinct chemical identities after resolving labels to ChEBI/PubChem/InChIKey, with unresolved names retained separately.

The current RDF snapshot is suitable for level 1, but it does not by itself prove that every article contains a named terpene. The `terpmed` panel is suitable for reproducible level-1 hit counts for its 25 predefined labels. A full literature-name census requires rerunning extraction over the PubMed title/abstract corpus, retaining `pmid`, exact matched span, normalized label, identity key, and evidence source.

### 7.1 Classification gate

An observed row is not counted as a terpene merely because it came from a table with a terpene-related name. Each record must pass a classification gate and retain four fields:

| Field | Meaning |
|---|---|
| `classification_evidence` | The actual evidence used: source-declared class, direct parent, ChEBI/PubChem link, or provisional structure QC flag. |
| `identity_key` | Standard InChIKey where available; otherwise a validated canonical-structure hash; null when no structure identity is available. |
| `classification_status` | `confirmed`, `probable`, `ambiguous`, or `excluded`. |
| `source_release` / `manifest` | The release, retrieval timestamp, immutable snapshot, and content hash needed to reproduce the result. |

The evidence hierarchy is:

1. source-declared terpene/terpenoid class or direct parent;
2. linked ChEBI/PubChem classification;
3. an explicit natural-products classifier retained by the source;
4. molecular formula or structure heuristics as provisional QC only.

Heuristics never establish terpene status on their own. COCONUT complete, SAIR, UNII, TCMID, vendor, reaction, assay, and measurement rows are excluded from molecule totals unless the individual record supplies qualifying chemical-class evidence and a chemical identity. Reaction enzymes and relation rows remain relations even when they point to a terpene molecule.

The headline result should therefore be a classification table, not one inflated number: confirmed identities, probable candidates, ambiguous records, excluded relation/measurement rows, and the deduplicated union of confirmed identities across sources.

## References

See [`sources.md`](sources.md) for links and provenance notes.

## 9. Organism provenance: who produces a terpene?

The current Terpedia data layer can often answer a weaker but measurable
question—**which organism or biological sample has been associated with a
compound?** It cannot automatically answer the stronger question—**which
organism biosynthesizes the compound?** A structure record alone contains no
organism evidence.

| Source | Organism or biological context available | Evidence level for production | Counting use |
|---|---|---|---|
| COCONUT | Source `organisms` field, plus collections and DOI fields | Reported natural-product source; preserve the original assertion and resolve names separately | Best immediate organism–compound join for the COCONUT records |
| LOTUS | Linked organism–compound–literature assertions | Reported occurrence when supported by its contributing source; source lineage is required | High-value future cross-source occurrence graph; current serving tier is raw/document |
| Dr. Duke | Plant, plant part, compound, concentration/activity, and literature fields | Reported phytochemical occurrence when a compound and plant record are linked; concentration and activity must not be conflated | Validated and promising for plant–compound occurrence |
| NAEB | Species and ethnobotanical-use records | Plant-use context, not evidence that the plant produces a particular terpene | Context only unless linked to a separate compound occurrence claim |
| KNApSAcK | Species–metabolite domain and mass-spectra records | Reported species–metabolite association; spectra support identity, not biosynthesis | Useful after licensing and field-level validation |
| EssoilDB | Essential-oil composition records | Measured or reported composition in an oil/sample, depending on record provenance | Useful for plant/sample composition; latest load has quality gaps |
| Cannabis profiles | Strain/sample name, provider, and terpene concentration measurements | Quantified sample composition; strain identity is not necessarily a taxonomically resolved organism | Strong for Cannabis sample/chemotype analysis, not general organism production |
| TeroKit | Molecules, categories, reactions, and enzymes | Chemical classification and biochemical relationships; no organism source by default | Molecule census and pathway context, not organism attribution |
| PubMed/Terport RDF | Article metadata and literature records | Literature mention unless the article text explicitly reports isolation, detection, or biosynthesis | Evidence discovery; requires extraction and manual/structured validation |

The organism graph should preserve the distinction among at least four claim
types:

1. `reported_in_species`: a source reports the compound in a named organism;
2. `quantified_in_sample`: an analytical sample contains a measured amount;
3. `isolated_from_species`: the compound was isolated from a biological source;
4. `biosynthesized_by_organism`: experimental or pathway evidence supports
   production by that organism.

These claims are not interchangeable. A strain label is not a taxon, a plant
name in a database is not proof of a measured compound, and a reaction or
terpene-synthase annotation is not proof that the complete pathway operates in
the named organism. Taxonomic names should be normalized through a versioned
backbone such as World Flora Online, Catalogue of Life, or NCBI Taxonomy while
retaining the original name exactly as reported.

The immediate census deliverable should therefore be a separate
organism-association table keyed by `identity_key` and containing:
`original_organism_name`, `normalized_taxon_id`, `organism_rank`, `plant_part`
or sample context, `claim_type`, `measurement_value` and units when present,
`source_record_id`, citation, release/manifest, and an evidence status. It
should report the number of distinct compounds with any organism association,
the number with quantified sample evidence, and the number with stronger
isolation or biosynthesis evidence. Those counts must not be merged into the
chemical-identity total.

The strongest near-term sources are COCONUT and Dr. Duke for reported plant
occurrence, the cannabis measurement view for sample composition, and LOTUS or
Plant Metabolic Network for literature-linked and pathway-level expansion.
