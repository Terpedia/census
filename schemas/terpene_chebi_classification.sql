-- ChEBI Release 239 classification of the dated T# candidate set.
-- Prerequisite: load the JSONL emitted by
-- scripts/chebi_ontology_classification.py as
-- terpedia_core.chebi_terpene_ontology_239_20260904.

CREATE OR REPLACE TABLE
  `terpedia-489015.terpedia_core.terpene_chebi_classification_20260904`
CLUSTER BY exact_match, connectivity_match AS
WITH chebi AS (
  SELECT
    chebi_id,
    inchikey,
    SPLIT(inchikey, '-')[SAFE_OFFSET(0)] AS connectivity,
    is_terpene_descendant,
    is_terpenoid_descendant
  FROM `terpedia-489015.terpedia_core.chebi_terpene_ontology_239_20260904`
  WHERE inchikey IS NOT NULL
), exact AS (
  SELECT
    t.terpene_id,
    ARRAY_AGG(DISTINCT c.chebi_id ORDER BY c.chebi_id) AS exact_chebi_ids,
    LOGICAL_OR(c.is_terpene_descendant) AS exact_terpene,
    LOGICAL_OR(c.is_terpenoid_descendant) AS exact_terpenoid
  FROM `terpedia-489015.terpedia_core.terpene_identity_set` AS t
  JOIN chebi AS c USING (inchikey)
  GROUP BY t.terpene_id
), connectivity AS (
  SELECT
    t.terpene_id,
    ARRAY_AGG(DISTINCT c.chebi_id ORDER BY c.chebi_id)
      AS connectivity_chebi_ids,
    LOGICAL_OR(c.is_terpene_descendant) AS connectivity_terpene,
    LOGICAL_OR(c.is_terpenoid_descendant) AS connectivity_terpenoid
  FROM `terpedia-489015.terpedia_core.terpene_identity_set` AS t
  JOIN chebi AS c
    ON SPLIT(t.inchikey, '-')[SAFE_OFFSET(0)] = c.connectivity
  GROUP BY t.terpene_id
)
SELECT
  t.terpene_id,
  t.inchikey,
  e.terpene_id IS NOT NULL AS exact_match,
  IFNULL(e.exact_chebi_ids, ARRAY<STRING>[]) AS exact_chebi_ids,
  IFNULL(e.exact_terpene, FALSE) AS exact_terpene,
  IFNULL(e.exact_terpenoid, FALSE) AS exact_terpenoid,
  c.terpene_id IS NOT NULL AS connectivity_match,
  IFNULL(c.connectivity_chebi_ids, ARRAY<STRING>[])
    AS connectivity_chebi_ids,
  IFNULL(c.connectivity_terpene, FALSE) AS connectivity_terpene,
  IFNULL(c.connectivity_terpenoid, FALSE) AS connectivity_terpenoid,
  'ChEBI Release 239' AS ontology_release,
  'CHEBI:35186 asserted named subclass closure UNION CHEBI:26873 asserted named subclass closure'
    AS ontology_boundary,
  '3df51b665dfa54499a41482a2456851983f50b709cefb4c5e9aaeb71a95e6814'
    AS source_sha256,
  CURRENT_TIMESTAMP() AS generated_at
FROM `terpedia-489015.terpedia_core.terpene_identity_set` AS t
LEFT JOIN exact AS e USING (terpene_id)
LEFT JOIN connectivity AS c USING (terpene_id);

CREATE OR REPLACE TABLE
  `terpedia-489015.terpedia_core.terpene_classification_evidence_20260904_v2`
CLUSTER BY chemical_evidence_tier, source_support_tier, qc_status AS
SELECT
  e.terpene_id,
  e.identity_set_key,
  CASE
    WHEN e.has_direct_marts_support
      THEN 'A_directly_characterized_tps_product'
    WHEN c.exact_match THEN 'B_chebi_ontology_confirmed'
    ELSE 'C_source_declared_candidate'
  END AS chemical_evidence_tier,
  e.source_support_tier,
  e.qc_status,
  e.has_direct_marts_support,
  c.exact_match AS has_exact_chebi_ontology_support,
  c.exact_terpene AS exact_chebi_terpene,
  c.exact_terpenoid AS exact_chebi_terpenoid,
  c.exact_chebi_ids,
  c.connectivity_match AS has_connectivity_chebi_candidate,
  c.connectivity_chebi_ids,
  e.fluorinated_formula_flag,
  e.disconnected_structure_flag,
  e.source_memberships,
  e.classification_statuses,
  e.classification_evidence,
  'Tier A is direct curated MARTS enzyme-product evidence; tier B is an exact full-InChIKey match to a non-obsolete class in the asserted ChEBI 239 CHEBI:35186/CHEBI:26873 subclass closures; connectivity-only ChEBI matches remain sensitivity evidence and do not confer tier B; all remaining source declarations are tier C candidates. QC flags are orthogonal.'
    AS claim_boundary,
  c.ontology_release,
  c.source_sha256 AS ontology_source_sha256,
  CURRENT_TIMESTAMP() AS generated_at
FROM `terpedia-489015.terpedia_core.terpene_classification_evidence_20260904`
  AS e
JOIN `terpedia-489015.terpedia_core.terpene_chebi_classification_20260904`
  AS c USING (terpene_id);
