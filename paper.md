# How many terpenes are there?

*Working draft — 2026-09-04*

## Abstract

The question “how many terpenes are there?” appears to invite a number, but the
literature supplies a moving family of numbers. A 2007 review described more
than 30,000 plant terpenoids; a 2020 review repeated more than 20,000 terpenes
in nature; a 2020 thesis distinguished about 8,000 terpenes from 30,000
terpenoids; and a 2023 study assembled 59,833 database records. These claims
count different chemical universes. In a dated Terpedia snapshot, exact
standard-InChI unioning of COCONUT and source-classified TeroKit records yields
268,924 candidate terpene/terpenoid identities, of which 225,905 have an exact
PubChem CID match. This is a candidate-identity census, not a count of
independently verified natural terpenes: source classification, chemical
identity, natural occurrence, experimental measurement, and biosynthetic
evidence remain separate assertions. We therefore report counts as scoped,
versioned tuples and quantify downstream coverage without treating it as proof
of terpene status or biological production.

## 1. The short answer

There is no defensible single number without a counting rule. A careful provisional answer is:

> **At least tens of thousands of naturally occurring terpene/terpenoid structures have been reported; the exact total depends on whether the count includes terpenoids, stereoisomers, conjugates, polymers, synonyms, and database-only records.**

The commonly repeated “55,000” figure should therefore be presented as an
estimate for the broad terpene/terpenoid universe, not as a precise count of
strict terpene hydrocarbons. Terpedia currently contains **268,924 candidate
identities in a two-source union**; it does not yet contain 268,924
independently validated terpenes.

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

The census uses three reporting tiers that must not be collapsed:

| Tier | Inclusion rule | Permitted interpretation |
|---|---|---|
| Source inventory | Every source row or source-declared member | Database volume only |
| Candidate identity census | Source-declared members deduplicated under a stated chemical-identity rule | Candidate terpene/terpenoid structures |
| Validated chemical census | Candidate identities passing an explicit chemical-class rule with auditable evidence | Confirmed structures within the declared definition |

The current 268,924 result belongs to the **candidate identity** tier. A
PubChem or ChEBI identifier resolves identity but does not by itself establish
terpene membership. The validated tier requires an explicit source class or
ontology path to a declared terpene/terpenoid class; structure heuristics may
flag candidates for review but cannot confirm them. Counts should also be
reported under multiple identity policies—stereochemistry-preserving,
standard-InChI, connectivity-only, and parent structure after salt/mixture
normalization—to expose sensitivity to deduplication choices.

## 6. Next work

- Resolve every Google search hyperlink on the TerpID slide to its underlying source; record title, author, date, and page/section.
- Retrieve the original references behind the 20,000, 30,000, and 55,000 estimates.
- Build a claim-level bibliography with publication date, exact quotation, page, and cited predecessor.
- Compare strict terpene and broad terpenoid counts using a fixed chemical-identity policy.
- Reproduce the 59,833-record dataset count if the underlying COCONUT release is available.
- Resolve PubChem CIDs for every assigned `T#` by InChI/InChIKey, retaining one-to-many and unresolved mappings.
- Add a figure showing estimates as labeled claims, with scope encoded separately from year.

## 7. Terpedia data census: BigQuery and RDF

The operational question is different from the historical question: **how many terpene/terpenoid identities does Terpedia currently hold, and how much overlap exists among its sources?** The answer must be computed from source snapshots, not inferred by adding table row counts.

The first confirmed BigQuery inventory gives these raw row counts:

| BigQuery source | Raw rows | Counting role |
|---|---:|---|
| `coconut_complete` | 695,133 | Broad COCONUT source table |
| `coconut_terpenoids` | 199,405 | Terpenoid subset; do not add to `coconut_complete` |
| `coconut_terpenoids_pubchem` | 177,449 | Has PubChem ID; derived subset; do not add to COCONUT totals |
| `terokit_molecules` | 337,904 | Molecule table |
| `terokit_purchasable_molecules` | 165,736 | Vendor relation/catalog; not an independent molecule universe |
| `terokit_reaction_molecules` | 9,584 | Reaction relation; not an independent molecule universe |
| `terokit_reaction_enzymes` | 27,974 | Enzyme relation; not a molecule count |

These are row counts, not the Terpedia total. The current two-source candidate
total is reported below; a complete Terpedia-wide or validated chemical total
does not yet exist because additional BigQuery and RDF sources remain outside
the classified identity union. Names and labels are discovery fields only and
cannot establish identity.

The materialized TeroKit classification view provides the first source-grounded
classification result. It contains **291,558 confirmed source-declared
terpenoid rows representing 145,354 distinct identities** after collapsing a
cross-category duplicate. A further **46,346 rows representing 23,061
identities** are marked ambiguous/not confirmed because their source categories
are `Others` or `Steroids`. The 145,354 figure is a TeroKit result pending
cross-source deduplication; it is not the Terpedia-wide total and source
category evidence is not independent chemical proof.

### 7.1 COCONUT–TeroKit cross-source union

The first executed cross-source set operation, run in BigQuery in `us-central1`
on 2026-09-03, found **268,924 unique chemical identities** across the
confirmed COCONUT terpenoid table and the confirmed source-declared TeroKit
terpenoid view. The source-specific sets contained 199,234 COCONUT identities
and 145,354 TeroKit identities, with **75,664 identities in common**:

`199,234 + 145,354 - 75,664 = 268,924`

The operation first deduplicated each source into a typed identity set using
`inchi:<standard InChI>`, then `inchikey:<InChIKey>`, then a labeled structure
fallback where necessary. All 344,588 source-set members in this run used the
standard-InChI key; no InChIKey or SMILES fallback was required. This is the
first measured Terpedia cross-source result, but it is not yet the Terpedia-wide
total. A final release should still retain both the original and canonical
keys and rerun the set operation after shared structure standardization. The result is stored in
[`data/reports/coconut-terokit-union-20260903.json`](data/reports/coconut-terokit-union-20260903.json).

### 7.2 Reaction-product and metabolic-network coverage

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

The later TerpNet integration supersedes this preliminary source-ID proxy.
Against the current T# corpus, the versioned v3 graph contains **827 T# product
identities** in stereochemistry-preserving (`isomeric`) edges and **5,128 T#
product identities** in the recall-oriented stereo-insensitive layer. The
strict layer contains 1,492 distinct product–precursor pairs; the relaxed layer
contains 124,928. The relaxed count is not added to the strict count because
it may connect distinct stereoisomers.

The coverage dashboard reports **5,130 of 268,924 T# identities (1.9076%)**
connected by either layer and **828 (0.3079%)** connected by strict edges. For
the 88,342 identities in canonical C10/C15/C20/C25/C30/C40 carbon-count
buckets, 2,258 (2.5560%) are connected and 373 (0.4222%) are strictly
connected. These are graph-coverage measures, not estimates of biological
pathway completeness: an edge is a structure-matched reaction hypothesis and
does not establish physiological direction, enzyme activity, organism-specific
production, or flux.

MARTS-DB contributes **4,639 reaction–enzyme assertions**, comprising 933
distinct reaction IDs, 1,532 enzyme IDs, 1,523 distinct amino-acid sequences,
840 product structures, and 46 substrate structures. Under a database-level
promiscuity definition—more than one distinct product structure linked to the
same enzyme ID—**863 enzymes (56.33%)** are multi-product, with a mean of 2.953
products and a maximum of 27. This models observed catalog multiplicity; it
does not prove that all linked products are formed under identical conditions
or in vivo. The executed results and claim boundaries are preserved in
[`data/reports/marts-network-coverage-20260904.json`](data/reports/marts-network-coverage-20260904.json).

### 7.3 Assigned Terpedia identity set

To make the union addressable for downstream curation, the 268,924-member
COCONUT–TeroKit set is materialized as the BigQuery table
`terpedia-489015.terpedia_core.terpene_identity_set`. Each row receives a
deterministic Terpedia identifier whose prefix records the carbon-count bucket
(`T10`, `T15`, `T20`, `T25`, `T30`, `T40`, or `TXX`). Assignment within a
bucket is ordered by carbon count and identity key and is therefore stable only
for the stated snapshot.

Each row retains the identity key type, InChI, InChIKey and SMILES when
available, source memberships, source record identifiers, classification
statuses, source releases, manifest URIs, and source-file URIs. The current
materialization uses the following priority for the set key:

1. `inchi:<standard InChI>`;
2. `inchikey:<InChIKey>`; and
3. `smiles:<structure>` as an explicitly labeled fallback.

All 268,924 current rows use the standard-InChI key. The `T#` identifier is a
Terpedia curation handle, not a chemical identifier and not a claim that the
record has independent experimental confirmation. Future refreshes must either
preserve the existing mapping or publish a versioned crosswalk before assigning
new T# values.

### 7.4 Cross-references into the T# set

The T# table now contains a repeated `source_crossrefs` field. Each element
stores the source name, source record ID, matched key type, release, manifest,
and source-file URI. Matching is exact on a typed standard InChI or InChIKey;
name-only matching is deliberately excluded. Cross-references are provenance
links and do not add new chemical identities to the T# set.

The refreshed table is `terpedia-489015.terpedia_core.terpene_identity_set`.
T# values now encode the carbon-count bucket: `T10`, `T15`, `T20`, `T25`,
`T30`, and `T40` identify the canonical mono-, sesqui-, di-, sester-, tri-,
and tetraterpene-sized groups; `TXX` is used for other or unresolved carbon
counts. Within each bucket, numbering is deterministic by carbon count and
identity key. It contains **268,924 T# rows**, and every one currently has at least one
cross-reference because the defining COCONUT/TeroKit membership is retained in
the same field. The external source coverage currently materialized is:

| Source | Distinct T# rows referenced | Cross-reference records |
|---|---:|---:|
| `coconut_terpenoids` | 199,234 | 199,405 |
| `coconut_complete` | 202,461 | 202,743 |
| `coconut_terpenoids_pubchem` | 177,313 | 177,449 |
| `terokit_classified` | 145,354 | 145,779 |
| `supernatural2_records` | 95,357 | 217,551 |
| `patent_compound_search` | 1,325 | 15,395 |
| `unii_records` | 3,204 | 3,331 |

This does **not** yet support the stronger statement that every terpene in
every Terpedia dataset is represented by a T#. The current T# set is defined
from COCONUT terpenoids plus confirmed TeroKit terpenoids. For the seven sources
above, all records with a usable key in the T# cross-reference query are
reported, but several sources contain many identities outside the current
terpene union. Other Terpedia sources are not yet safely matchable at the
record level: some are reaction, measurement, organism, or literature
relations; others need PubChem/ChEBI or structure normalization first. These
include the current Rhea/ChEBI/PubChem RDF layer, LOTUS, Dr. Duke, NAEB,
TCMID, BRENDA, cannabis measurement tables, CannabisDB, KNApSAcK, EssoilDB,
and SAIR relation tables. They must be added through explicit identifier
crosswalks, not inferred from names.

The remap was protected by the versioned table
`terpedia-489015.terpedia_core.terpene_identity_set_pre_remap_20260904` and
the old-to-new table
`terpedia-489015.terpedia_core.terpene_id_crosswalk_20260904`; both contain
268,924 identity rows.

Thus the defensible current claim is: **all 268,924 T# identities have at
least one exact-key provenance link, but complete all-dataset coverage has not
yet been demonstrated.**

### 7.5 Structure-based ordering

The T# table is accompanied by the versioned table
`terpedia-489015.terpedia_core.terpene_similarity_order_20260904`. All
268,924 structures parsed successfully with RDKit. The ordering groups exact
Bemis–Murcko scaffolds, producing 93,206 scaffold groups, and uses a 2,048-bit
Morgan fingerprint hash as a deterministic tie-breaker. This is a scaffold
family ordering, not a claim that adjacent rows have a quantified Tanimoto
similarity. T# remains the identity handle; `similarity_rank` is a replaceable,
versioned presentation order.

### 7.6 Evidence provenance and commercial availability

The current T# census preserves database and file provenance, but it does not
yet assign a uniform experimental-evidence status to every identity. COCONUT
records retain source identifiers, collection labels, organisms, DOIs,
release, manifest, and source-file provenance. These establish that the
compound was aggregated as a natural product; they do not by themselves show
whether it was isolated, analytically measured, computationally predicted, or
copied from another database. COCONUT's `np_classifier_*` fields are
computational classifications and must remain distinguishable from reported
organism occurrence and experimental measurements.

TeroKit contributes explicit source categories, reactions, enzymes, and
vendor records. The T# gate accepts only TeroKit's explicit terpene/terpenoid
categories as `confirmed_source_declared_terpenoid`; this is confirmation of
the source declaration, not independent ChEBI/PubChem classification or
experimental production evidence. PubChem CID resolution likewise confirms a
chemical identifier match, not terpene classification, natural occurrence,
or experimental measurement.

TeroKit currently marks **16,238 source molecule records** as purchasable.
After identity resolution, these correspond to **13,095 distinct T#
identities** (4.87% of the T# set) and 235 vendor labels. A further 3,143
purchasable TeroKit source records do not map into the confirmed T# set.
`Purchasable` here means present in the ingested TeroKit vendor snapshot; it
does not establish current stock, price, purity, shipping eligibility, or
continued vendor operation.

Independent commercial confirmation should be represented as a separate,
time-varying assertion table rather than embedded in chemical identity. Each
observation should preserve `terpene_id`, vendor, vendor SKU, product URL,
catalog release or retrieval timestamp, availability status, price and
currency when redistribution is permitted, matched chemical key, source
artifact checksum, and verification method. Aggregators and historical
collections—including eMolecules, MolPort, Chemspace, make-on-demand
collections, and dated NCI plates—must not be treated as equivalent to a
current first-party in-stock listing.

### 7.7 Lipinski Rule-of-Five profile

All 268,924 T# SMILES parsed successfully with RDKit. Applying the standard
four Rule-of-Five thresholds—molecular weight no greater than 500 Da, calculated
logP no greater than 5, no more than 5 hydrogen-bond donors, and no more than
10 hydrogen-bond acceptors—produced the following distribution:

| Rule-of-Five violations | T# identities |
|---:|---:|
| 0 | 126,439 |
| 1 | 65,648 |
| 2 | 42,044 |
| 3 | 34,000 |
| 4 | 793 |

Thus **126,439 T# identities (47.02%) meet all four Lipinski thresholds**.
This is a computed physicochemical profile, not evidence of oral bioavailability,
safety, efficacy, natural occurrence, or terpene classification. Many natural
products fall outside the Rule of Five while remaining biologically relevant.

### 7.8 PubChem BioAssay coverage

The full-corpus exact-InChIKey lookup produced 225,905 T# identities mapping to
226,050 distinct PubChem CIDs. A grouped PubChem PUG REST CID-to-AID query then
found **29,251 T# identities with at least one BioAssay association**. This is
10.8771% of all 268,924 T# identities and 12.9484% of T# identities with an
exact PubChem match. **94,733 distinct PubChem BioAssays** test at least one
mapped T# identity. At the CID level, 29,254 CIDs have assay data, forming
800,959 distinct CID–AID links.

Using PubChem's CID-level `aids_type` filters, 8,199 T# identities have at
least one active association and 5,171 have at least one inactive association.
Because an identity can have both, the mutually exclusive partition is:

| T# BioAssay status | T# identities |
|---|---:|
| Active association(s), no inactive association | 5,818 |
| Inactive association(s), no active association | 2,790 |
| Both active and inactive associations | 2,381 |
| Assay participation without active/inactive AID classification | 18,262 |
| No assay association | 239,673 |

Across assays, 22,955 AIDs are active for at least one mapped CID, 3,514 are
inactive for at least one, and 1,937 occur in both sets. Their union is 24,532
AIDs; the other 70,201 participating AIDs are not classified as active or
inactive for these CIDs by this endpoint. Participation still does not imply a
unique biological target or that PubChem classifies the identity as a terpene.
Separating inconclusive from unspecified outcomes requires result-level assay
summaries and must not be inferred from identifier associations.

The queries are reproducible with
[`scripts/search_pubchem_bioassays.py`](scripts/search_pubchem_bioassays.py);
the aggregate and outcome results are
[`data/reports/pubchem-bioassay-20260904.json`](data/reports/pubchem-bioassay-20260904.json),
[`data/reports/pubchem-bioassay-outcomes-20260904.json`](data/reports/pubchem-bioassay-outcomes-20260904.json),
and the grouped CID–AID data are materialized as
`terpene_pubchem_bioassay_lookup_20260904`,
`terpene_pubchem_bioassay_active_lookup_20260904`, and
`terpene_pubchem_bioassay_inactive_lookup_20260904` in
`terpedia-489015.terpedia_core`.

### 7.9 Classification and structure-quality audit

An initial whole-corpus quality screen demonstrates why source declaration
cannot be equated with validated terpene membership. Although every T# row has
a standard InChI, 69,690 rows lack a stored InChIKey and 1,235 SMILES contain
multiple disconnected components. InChIKeys can be recomputed, but the missing
field prevents a stored-key audit from covering the full corpus without that
normalization step.

Atom-level parsing found **584 fluorinated structures**, all in the
TeroKit-defined candidate set. A naive formula search initially overcounted
five iron-containing COCONUT structures because `Fe` contains the character
`F`; this failed check is retained as a warning against text-only chemical
quality control. Fluorination is a review flag rather than a universal
exclusion because rare natural organofluorines exist. However, records such as
`T10000001` (`C10F14`), admitted solely through a TeroKit category, are
incompatible with an ordinary biosynthetic-terpene interpretation absent
extraordinary source evidence. Such records must be reviewed or excluded from
the validated tier while remaining traceable in the source and candidate
tiers. The dated aggregate and example are preserved in
[`data/reports/classification-qc-20260904.json`](data/reports/classification-qc-20260904.json).

### 7.10 Identity-policy sensitivity

Recomputation from all 268,924 T# SMILES with RDKit 2026.03.6 produced 268,919
distinct standard InChIs, full InChIKeys, and canonical isomeric SMILES. Thus
five identities in the source-keyed table collide after one shared parsing and
identifier-generation pipeline. Removing stereochemistry reduced the count to
137,065 canonical SMILES; the first InChIKey connectivity block produced
136,713 groups. Applying RDKit's fragment-parent operation to disconnected
structures yielded 268,841 full keys and 136,046 connectivity groups.

| Identity policy | Distinct structures/groups |
|---|---:|
| Source-keyed T# rows | 268,924 |
| Recomputed standard InChI/full InChIKey | 268,919 |
| Canonical isomeric SMILES | 268,919 |
| Canonical non-isomeric SMILES | 137,065 |
| InChIKey connectivity block | 136,713 |
| Fragment-parent full InChIKey | 268,841 |
| Fragment-parent connectivity block | 136,046 |

These are sensitivity analyses, not competing claims that one policy is
universally correct. The nearly twofold difference after stereochemistry is
removed shows why every reported census must declare whether stereoisomers are
counted separately. The executable analysis and dated output are
[`scripts/identity_sensitivity.py`](scripts/identity_sensitivity.py) and
[`data/reports/identity-sensitivity-20260904.json`](data/reports/identity-sensitivity-20260904.json).

The final report should publish at least three totals:

1. source-row counts;
2. unique chemical identities in each source; and
3. the union of unique identities across the selected molecule sources, with pairwise and multiway overlap.

The Colab notebook is read-only with respect to BigQuery. It should run the queries in [`queries.sql`](queries.sql), save result tables and the exact query timestamp, and never print or store the API key.

## 8. PubChem coverage

PubChem does not provide one canonical, database-wide count called “terpenes.”
Its Classification Browser exposes counts by classification system and node,
and those counts are unique PubChem records annotated by the selected
classification. A name search for *terpene* is not equivalent to a structural
class count.

The initial Terpedia inventory contained 177,449 rows in a COCONUT-derived
“has PubChem ID” subset, representing 177,313 T# identities. An earlier audit
combined that imported source flag with exact lookup of only the remaining
identities and estimated 226,021 matches. Because the two components had
different mapping provenance, every T# identity was subsequently requeried by
exact InChIKey on 2026-09-04. The uniform audit found **225,905 of 268,924 T#
identities (84.0033%)** with at least one exact CID and 43,019 without one;
121 T# identities returned more than one CID, for 226,050 distinct CIDs. The
116-identity difference from the mixed estimate demonstrates why source flags
and exact current lookups should not be added without revalidation.

The authoritative full-corpus table for this snapshot is
`terpedia-489015.terpedia_core.terpene_pubchem_lookup_all_20260904`, with its
aggregate audit in
[`data/reports/pubchem-complete-lookup-20260904.json`](data/reports/pubchem-complete-lookup-20260904.json).
The earlier missing-only table is retained as provenance, not as the current
coverage denominator.

An exact CID match confirms only that PubChem contains the same standardized
structure. It does not mean PubChem classifies the compound as a terpene, nor
does it establish biological occurrence or experimental measurement. The
COCONUT subset and newly resolved CIDs are therefore identifier coverage, not
the number of terpenes in PubChem. A reproducible PubChem-wide class result
must state the classification system
(for example, ChEBI, KEGG, or PubChem Chemical Classes), selected node,
record type (CID or SID), retrieval date, and whether descendants are
included. Strict terpene and broad terpenoid counts should be reported
separately, with overlap documented where the classification systems differ.

## 9. Terpenes mentioned in PubMed literature

Terpedia has a separate literature quantity: compounds named in PubMed-indexed records. This is not the same as the number of chemical identities in BigQuery or RDF. A paper can mention a terpene class without naming a molecule, and one molecule can appear under many spelling, stereochemical, and synonym forms.

The existing Terpedia literature snapshot is `terport/ttl/pubmed_terpenes.ttl`, generated by [`terport/src/update_from_pubmed.py`](../terport/src/update_from_pubmed.py). In the current local snapshot, it contains **6,500 distinct PMID identifiers / journal-article records**. This is a retrieval-snapshot count, not yet a validated count of terpene-positive articles. The companion `terpmed/public/results.json` contains a targeted PubMed query panel with **25 queried compound labels** and per-label hit counts; those labels are a search panel, not a census of all terpene names in PubMed.

A newer function-by-terpene panel in
`terpedia-489015.terpedia_raw.pubmed_function_terpene_cooccurrence` contains
1,925 rows spanning 74 distinct function labels and 25 terpene labels. The
source grid repeats `Fibromyalgia`, `Osteoporosis`, and `neuroprotective` once
each across all 25 terpenes, creating 75 duplicate rows. After exact pair
deduplication, **1,850 function–terpene queries** remain; 657 have nonzero
PubMed hit counts and 1,193 have zero. The sum of the deduplicated pair counts
is 10,077, but this is query-pair volume, **not 10,077 unique articles**, because
one PMID can satisfy multiple queries. The labels are not yet resolved to T#
identities. The audit is preserved in
[`data/reports/pubmed-function-cooccurrence-20260904.json`](data/reports/pubmed-function-cooccurrence-20260904.json).

The paper should report literature coverage at three levels:

1. **article mentions:** distinct PubMed IDs whose title, abstract, or indexed fields matched the retrieval query;
2. **name mentions:** distinct normalized terpene/terpenoid labels extracted from article text or query panels; and
3. **identity-linked mentions:** distinct chemical identities after resolving labels to ChEBI/PubChem/InChIKey, with unresolved names retained separately.

The current RDF snapshot is suitable for level 1, but it does not by itself prove that every article contains a named terpene. The `terpmed` panel is suitable for reproducible level-1 hit counts for its 25 predefined labels. A full literature-name census requires rerunning extraction over the PubMed title/abstract corpus, retaining `pmid`, exact matched span, normalized label, identity key, and evidence source.

### 9.1 Classification gate

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

## 10. Organism provenance: who produces a terpene?

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

## 11. Limitations and publication-grade completion criteria

The principal numerical result is presently a **candidate identity census**.
Its false-positive rate as a terpene/terpenoid census is unknown because no
stratified per-record chemical-class validation has yet been completed. Its
false-negative rate is also unknown because several Terpedia sources and
structures lacking resolvable identifiers remain outside the union. The
standard-InChI result is sensitive to normalization choices, and no current
single number captures all stereoisomer, tautomer, salt, mixture, and parent
structure interpretations.

Before the candidate total is promoted to a validated census, a release must:

1. materialize a per-T# classification-evidence table with explicit ontology
   ancestry or source-class evidence, retaining ambiguous and excluded rows;
2. report identity-count sensitivity under stereochemistry-preserving,
   standard-InChI, connectivity-only, and normalized-parent policies;
3. perform a preregistered, source- and scaffold-stratified manual audit and
   report positive predictive value with confidence intervals;
4. publish a source-flow table showing raw rows, structure-resolved rows,
   classified candidates, exclusions, within-source duplicates, overlaps, and
   final union membership;
5. pin source releases, query text, software and RDKit versions, retrieval
   timestamps, checksums, and immutable result artifacts; and
6. distinguish missing evidence from negative evidence in every organism,
   assay, reaction, literature, and commercial-availability result.

Until these conditions are met, the defensible wording is “268,924 candidate
terpene/terpenoid identities from the stated COCONUT–TeroKit snapshot,” not
“268,924 terpenes.”

## References

See [`sources.md`](sources.md) for links and provenance notes.
