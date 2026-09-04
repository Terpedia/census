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

## References

See [`sources.md`](sources.md) for links and provenance notes.
