-- Expand the T# registry with exact ChEBI Release 239 terpene/terpenoid
-- identities while preserving every existing T# assignment. This writes a
-- versioned candidate table first; do not replace terpene_identity_set until
-- the invariants at the end of this file pass.

CREATE TABLE IF NOT EXISTS
  `terpedia-489015.terpedia_core.terpene_identity_set_pre_chebi_20260904`
AS
SELECT * FROM `terpedia-489015.terpedia_core.terpene_identity_set`;

CREATE OR REPLACE TABLE
  `terpedia-489015.terpedia_core.terpene_identity_set_with_chebi_20260904`
CLUSTER BY terpene_id AS
WITH chebi_grouped AS (
  SELECT
    inchi,
    inchikey,
    MIN(smiles) AS smiles,
    MIN(formula) AS molecular_formula,
    ARRAY_AGG(DISTINCT chebi_id ORDER BY chebi_id) AS chebi_ids,
    LOGICAL_OR(is_terpene_descendant) AS is_terpene,
    LOGICAL_OR(is_terpenoid_descendant) AS is_terpenoid
  FROM `terpedia-489015.terpedia_core.chebi_terpene_ontology_239_20260904`
  WHERE inchikey IS NOT NULL AND inchi IS NOT NULL
  GROUP BY inchi, inchikey
), existing_augmented AS (
  SELECT
    t.terpene_id,
    t.identity_set_key,
    t.identity_key_type,
    t.inchi,
    t.inchikey,
    t.smiles,
    t.molecular_formula,
    t.carbon_count,
    t.terpene_size_class,
    ARRAY_CONCAT(
      t.source_memberships,
      IF(c.inchikey IS NULL, ARRAY<STRING>[], ['chebi_ontology'])
    ) AS source_memberships,
    ARRAY_CONCAT(
      t.source_record_ids,
      IFNULL(c.chebi_ids, ARRAY<STRING>[])
    ) AS source_record_ids,
    ARRAY_CONCAT(
      t.classification_statuses,
      IF(c.inchikey IS NULL, ARRAY<STRING>[],
        ARRAY(
          SELECT status FROM UNNEST([
            IF(c.is_terpene, 'ontology_confirmed_terpene', NULL),
            IF(c.is_terpenoid, 'ontology_confirmed_terpenoid', NULL)
          ]) AS status WHERE status IS NOT NULL
        ))
    ) AS classification_statuses,
    ARRAY_CONCAT(
      t.classification_evidence,
      IF(c.inchikey IS NULL, ARRAY<STRING>[],
        ['ChEBI_239_asserted_named_subclass_closure'])
    ) AS classification_evidence,
    ARRAY_CONCAT(
      t.source_releases,
      IF(c.inchikey IS NULL, ARRAY<STRING>[], ['ChEBI Release 239'])
    ) AS source_releases,
    ARRAY_CONCAT(
      t.manifest_uris,
      IF(c.inchikey IS NULL, ARRAY<STRING>[],
        ['gs://terpedia-knowledge-raw/manifests/tonsync/20260902T061227Z.json'])
    ) AS manifest_uris,
    ARRAY_CONCAT(
      t.source_file_uris,
      IF(c.inchikey IS NULL, ARRAY<STRING>[],
        ['gs://terpedia-knowledge-raw/raw/chebi/objects/3df51b665dfa54499a41482a2456851983f50b709cefb4c5e9aaeb71a95e6814/chebi.owl'])
    ) AS source_file_uris,
    ARRAY_CONCAT(
      t.source_crossrefs,
      IF(c.inchikey IS NULL,
        ARRAY<STRUCT<source_name STRING, source_record_id STRING,
          matched_key_type STRING, source_release STRING,
          manifest_uri STRING, source_file_uri STRING>>[],
        ARRAY(
          SELECT AS STRUCT
            'chebi_ontology' AS source_name,
            chebi_id AS source_record_id,
            'exact_full_inchikey' AS matched_key_type,
            'ChEBI Release 239' AS source_release,
            'gs://terpedia-knowledge-raw/manifests/tonsync/20260902T061227Z.json'
              AS manifest_uri,
            'gs://terpedia-knowledge-raw/raw/chebi/objects/3df51b665dfa54499a41482a2456851983f50b709cefb4c5e9aaeb71a95e6814/chebi.owl'
              AS source_file_uri
          FROM UNNEST(c.chebi_ids) AS chebi_id
        ))
    ) AS source_crossrefs,
    t.generated_at
  FROM `terpedia-489015.terpedia_core.terpene_identity_set` AS t
  LEFT JOIN chebi_grouped AS c USING (inchikey)
), new_base AS (
  SELECT
    c.*,
    CASE
      WHEN REGEXP_CONTAINS(c.molecular_formula, r'C[0-9]+')
        THEN CAST(REGEXP_EXTRACT(c.molecular_formula, r'C([0-9]+)') AS INT64)
      WHEN REGEXP_CONTAINS(c.molecular_formula, r'C([^a-z]|$)') THEN 1
      ELSE NULL
    END AS carbon_count
  FROM chebi_grouped AS c
  LEFT JOIN `terpedia-489015.terpedia_core.terpene_identity_set` AS t
    USING (inchikey)
  WHERE t.terpene_id IS NULL
), new_bucketed AS (
  SELECT
    *,
    CASE carbon_count
      WHEN 10 THEN 'T10'
      WHEN 15 THEN 'T15'
      WHEN 20 THEN 'T20'
      WHEN 25 THEN 'T25'
      WHEN 30 THEN 'T30'
      WHEN 40 THEN 'T40'
      ELSE 'TXX'
    END AS bucket,
    CASE carbon_count
      WHEN 10 THEN 'monoterpene (C10)'
      WHEN 15 THEN 'sesquiterpene (C15)'
      WHEN 20 THEN 'diterpene (C20)'
      WHEN 25 THEN 'sesterterpene (C25)'
      WHEN 30 THEN 'triterpene (C30)'
      WHEN 40 THEN 'tetraterpene (C40)'
      ELSE 'other carbon count'
    END AS terpene_size_class
  FROM new_base
), maxima AS (
  SELECT
    SUBSTR(terpene_id, 1, 3) AS bucket,
    MAX(CAST(SUBSTR(terpene_id, 4) AS INT64)) AS max_suffix
  FROM `terpedia-489015.terpedia_core.terpene_identity_set`
  GROUP BY bucket
), new_ranked AS (
  SELECT
    n.*,
    m.max_suffix + ROW_NUMBER() OVER (
      PARTITION BY n.bucket ORDER BY n.inchi, n.inchikey
    ) AS suffix
  FROM new_bucketed AS n
  JOIN maxima AS m USING (bucket)
), new_rows AS (
  SELECT
    CONCAT(bucket, LPAD(CAST(suffix AS STRING), 6, '0')) AS terpene_id,
    CONCAT('inchi:', inchi) AS identity_set_key,
    'inchi' AS identity_key_type,
    inchi,
    inchikey,
    smiles,
    molecular_formula,
    carbon_count,
    terpene_size_class,
    ['chebi_ontology'] AS source_memberships,
    chebi_ids AS source_record_ids,
    ARRAY(
      SELECT status FROM UNNEST([
        IF(is_terpene, 'ontology_confirmed_terpene', NULL),
        IF(is_terpenoid, 'ontology_confirmed_terpenoid', NULL)
      ]) AS status WHERE status IS NOT NULL
    ) AS classification_statuses,
    ['ChEBI_239_asserted_named_subclass_closure'] AS classification_evidence,
    ['ChEBI Release 239'] AS source_releases,
    ['gs://terpedia-knowledge-raw/manifests/tonsync/20260902T061227Z.json']
      AS manifest_uris,
    ['gs://terpedia-knowledge-raw/raw/chebi/objects/3df51b665dfa54499a41482a2456851983f50b709cefb4c5e9aaeb71a95e6814/chebi.owl']
      AS source_file_uris,
    ARRAY(
      SELECT AS STRUCT
        'chebi_ontology' AS source_name,
        chebi_id AS source_record_id,
        'exact_full_inchikey' AS matched_key_type,
        'ChEBI Release 239' AS source_release,
        'gs://terpedia-knowledge-raw/manifests/tonsync/20260902T061227Z.json'
          AS manifest_uri,
        'gs://terpedia-knowledge-raw/raw/chebi/objects/3df51b665dfa54499a41482a2456851983f50b709cefb4c5e9aaeb71a95e6814/chebi.owl'
          AS source_file_uri
      FROM UNNEST(chebi_ids) AS chebi_id
    ) AS source_crossrefs,
    CURRENT_TIMESTAMP() AS generated_at
  FROM new_ranked
)
SELECT * FROM existing_augmented
UNION ALL
SELECT * FROM new_rows;

-- Required invariants: 273,646 rows, no duplicate T#, no duplicate identity
-- key, 268,924 unchanged old T# mappings, and 11,307 exact ChEBI keys covered.
SELECT
  COUNT(*) AS rows,
  COUNT(DISTINCT terpene_id) AS distinct_t_ids,
  COUNT(DISTINCT identity_set_key) AS distinct_identity_keys,
  COUNTIF(ARRAY_LENGTH(source_crossrefs) = 0) AS rows_without_crossrefs,
  COUNTIF('chebi_ontology' IN UNNEST(source_memberships)) AS chebi_t_ids
FROM `terpedia-489015.terpedia_core.terpene_identity_set_with_chebi_20260904`;

SELECT COUNT(*) AS changed_existing_t_ids
FROM `terpedia-489015.terpedia_core.terpene_identity_set_pre_chebi_20260904` AS old
JOIN `terpedia-489015.terpedia_core.terpene_identity_set_with_chebi_20260904` AS new
  USING (identity_set_key)
WHERE old.terpene_id != new.terpene_id;
