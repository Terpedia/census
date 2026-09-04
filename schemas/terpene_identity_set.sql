-- Canonical COCONUT + TeroKit terpene/terpenoid identity set.
-- Execute in BigQuery location us-central1 after the source tables/views exist.
-- T# is deterministic for this snapshot: lexical order of identity_set_key.
CREATE OR REPLACE TABLE `terpedia-489015.terpedia_core.terpene_identity_set` AS
WITH coconut AS (
  SELECT
    CASE
      WHEN NULLIF(TRIM(standard_inchi), '') IS NOT NULL
        THEN CONCAT('inchi:', TRIM(standard_inchi))
      WHEN NULLIF(TRIM(standard_inchi_key), '') IS NOT NULL
        THEN CONCAT('inchikey:', TRIM(standard_inchi_key))
      WHEN NULLIF(TRIM(canonical_smiles), '') IS NOT NULL
        THEN CONCAT('smiles:', TRIM(canonical_smiles))
    END AS identity_set_key,
    NULLIF(TRIM(standard_inchi), '') AS inchi,
    NULLIF(TRIM(standard_inchi_key), '') AS inchikey,
    NULLIF(TRIM(canonical_smiles), '') AS smiles,
    NULLIF(TRIM(molecular_formula), '') AS molecular_formula,
    identifier AS source_record_id,
    source_release,
    manifest_uri,
    source_file_uri,
    'coconut_terpenoids' AS source_name,
    'source_declared_terpenoid' AS classification_status,
    'coconut_chemical_classification' AS classification_evidence
  FROM `terpedia-489015.terpedia_raw.coconut_terpenoids`
), terokit AS (
  SELECT
    CASE
      WHEN NULLIF(TRIM(inchi), '') IS NOT NULL
        THEN CONCAT('inchi:', TRIM(inchi))
      WHEN NULLIF(TRIM(smiles), '') IS NOT NULL
        THEN CONCAT('smiles:', TRIM(smiles))
    END AS identity_set_key,
    NULLIF(TRIM(inchi), '') AS inchi,
    CAST(NULL AS STRING) AS inchikey,
    NULLIF(TRIM(smiles), '') AS smiles,
    NULLIF(TRIM(formula), '') AS molecular_formula,
    source_record_id,
    source_release,
    manifest_uri,
    source_file_uri,
    'terokit_classified' AS source_name,
    classification_status,
    classification_evidence
  FROM `terpedia-489015.terpedia_raw.terokit_molecule_classification`
  WHERE classification_status = 'confirmed_source_declared_terpenoid'
), members AS (
  SELECT * FROM coconut WHERE identity_set_key IS NOT NULL
  UNION ALL
  SELECT * FROM terokit WHERE identity_set_key IS NOT NULL
), grouped AS (
  SELECT
    identity_set_key,
    ARRAY_AGG(DISTINCT source_name ORDER BY source_name) AS source_memberships,
    ARRAY_AGG(DISTINCT source_record_id IGNORE NULLS ORDER BY source_record_id)
      AS source_record_ids,
    ARRAY_AGG(DISTINCT inchi IGNORE NULLS ORDER BY inchi LIMIT 1)[SAFE_OFFSET(0)]
      AS inchi,
    ARRAY_AGG(DISTINCT inchikey IGNORE NULLS ORDER BY inchikey LIMIT 1)[SAFE_OFFSET(0)]
      AS inchikey,
    ARRAY_AGG(DISTINCT smiles IGNORE NULLS ORDER BY smiles LIMIT 1)[SAFE_OFFSET(0)]
      AS smiles,
    ARRAY_AGG(DISTINCT molecular_formula IGNORE NULLS ORDER BY molecular_formula LIMIT 1)[SAFE_OFFSET(0)]
      AS molecular_formula,
    ARRAY_AGG(DISTINCT classification_status ORDER BY classification_status)
      AS classification_statuses,
    ARRAY_AGG(DISTINCT classification_evidence ORDER BY classification_evidence)
      AS classification_evidence,
    ARRAY_AGG(DISTINCT source_release IGNORE NULLS ORDER BY source_release)
      AS source_releases,
    ARRAY_AGG(DISTINCT manifest_uri IGNORE NULLS ORDER BY manifest_uri)
      AS manifest_uris,
    ARRAY_AGG(DISTINCT source_file_uri IGNORE NULLS ORDER BY source_file_uri)
      AS source_file_uris
  FROM members
  GROUP BY identity_set_key
), classified AS (
  SELECT
    g.*,
    SAFE_CAST(REGEXP_EXTRACT(molecular_formula, r'C([0-9]+)') AS INT64)
      AS carbon_count
  FROM grouped AS g
), classified_ordered AS (
  SELECT
    c.*,
    CASE
      WHEN carbon_count = 10 THEN '10'
      WHEN carbon_count = 15 THEN '15'
      WHEN carbon_count = 20 THEN '20'
      WHEN carbon_count = 25 THEN '25'
      WHEN carbon_count = 30 THEN '30'
      WHEN carbon_count = 40 THEN '40'
      ELSE 'XX'
    END AS terpene_size_code,
    ROW_NUMBER() OVER (
      PARTITION BY CASE
        WHEN carbon_count = 10 THEN '10'
        WHEN carbon_count = 15 THEN '15'
        WHEN carbon_count = 20 THEN '20'
        WHEN carbon_count = 25 THEN '25'
        WHEN carbon_count = 30 THEN '30'
        WHEN carbon_count = 40 THEN '40'
        ELSE 'XX'
      END
      ORDER BY carbon_count, identity_set_key
    ) AS terpene_size_number
  FROM classified AS c
), source_crossrefs AS (
  SELECT
    CASE
      WHEN NULLIF(TRIM(standard_inchi), '') IS NOT NULL
        THEN CONCAT('inchi:', TRIM(standard_inchi))
      WHEN NULLIF(TRIM(standard_inchi_key), '') IS NOT NULL
        THEN CONCAT('inchikey:', TRIM(standard_inchi_key))
    END AS identity_lookup_key,
    'coconut_terpenoids' AS source_name,
    identifier AS source_record_id,
    CASE
      WHEN NULLIF(TRIM(standard_inchi), '') IS NOT NULL THEN 'standard_inchi'
      ELSE 'inchikey'
    END AS matched_key_type,
    source_release, manifest_uri, source_file_uri
  FROM `terpedia-489015.terpedia_raw.coconut_terpenoids`
  UNION ALL
  SELECT
    CASE
      WHEN NULLIF(TRIM(standard_inchi), '') IS NOT NULL
        THEN CONCAT('inchi:', TRIM(standard_inchi))
      WHEN NULLIF(TRIM(standard_inchi_key), '') IS NOT NULL
        THEN CONCAT('inchikey:', TRIM(standard_inchi_key))
    END AS identity_lookup_key,
    'coconut_complete' AS source_name,
    identifier AS source_record_id,
    CASE
      WHEN NULLIF(TRIM(standard_inchi), '') IS NOT NULL THEN 'standard_inchi'
      ELSE 'inchikey'
    END AS matched_key_type,
    source_release, manifest_uri, source_file_uri
  FROM `terpedia-489015.terpedia_raw.coconut_complete`
  UNION ALL
  SELECT
    CASE
      WHEN NULLIF(TRIM(standard_inchi), '') IS NOT NULL
        THEN CONCAT('inchi:', TRIM(standard_inchi))
      WHEN NULLIF(TRIM(standard_inchi_key), '') IS NOT NULL
        THEN CONCAT('inchikey:', TRIM(standard_inchi_key))
    END,
    'coconut_terpenoids_pubchem', identifier,
    CASE
      WHEN NULLIF(TRIM(standard_inchi), '') IS NOT NULL THEN 'standard_inchi'
      ELSE 'inchikey'
    END,
    source_release, manifest_uri, source_file_uri
  FROM `terpedia-489015.terpedia_raw.coconut_terpenoids_pubchem`
  UNION ALL
  SELECT
    CASE
      WHEN NULLIF(TRIM(inchi), '') IS NOT NULL
        THEN CONCAT('inchi:', TRIM(inchi))
      WHEN NULLIF(TRIM(smiles), '') IS NOT NULL
        THEN CONCAT('smiles:', TRIM(smiles))
    END,
    'terokit_classified', source_record_id,
    CASE WHEN NULLIF(TRIM(inchi), '') IS NOT NULL THEN 'standard_inchi' ELSE 'smiles' END,
    source_release, manifest_uri, source_file_uri
  FROM `terpedia-489015.terpedia_raw.terokit_molecule_classification`
  WHERE classification_status = 'confirmed_source_declared_terpenoid'
  UNION ALL
  SELECT
    CONCAT('inchikey:', TRIM(inchi_key)),
    'patent_compound_search', id, 'inchikey',
    source_release, manifest_uri, source_file_uri
  FROM `terpedia-489015.terpedia_raw.patent_compound_search`
  WHERE NULLIF(TRIM(inchi_key), '') IS NOT NULL
  UNION ALL
  SELECT
    CONCAT('inchikey:', TRIM(inchi_key)),
    'supernatural2_records', id, 'inchikey',
    source_release, manifest_uri, source_file_uri
  FROM `terpedia-489015.terpedia_raw.supernatural2_records`
  WHERE NULLIF(TRIM(inchi_key), '') IS NOT NULL
  UNION ALL
  SELECT
    CONCAT('inchikey:', TRIM(INCHIKEY)),
    'unii_records', UNII, 'inchikey',
    source_release, manifest_uri, source_file_uri
  FROM `terpedia-489015.terpedia_raw.unii_records`
  WHERE NULLIF(TRIM(INCHIKEY), '') IS NOT NULL
), aliases AS (
  SELECT DISTINCT identity_set_key AS identity_set_key, identity_set_key AS lookup_key
  FROM grouped
  UNION DISTINCT
  SELECT DISTINCT identity_set_key, CONCAT('inchikey:', inchikey)
  FROM grouped
  WHERE inchikey IS NOT NULL
), xref_dedup AS (
  SELECT DISTINCT
    identity_lookup_key,
    source_name,
    source_record_id,
    matched_key_type,
    source_release,
    manifest_uri,
    source_file_uri
  FROM source_crossrefs
  WHERE identity_lookup_key IS NOT NULL
), ref_groups AS (
  SELECT
    a.identity_set_key,
    ARRAY_AGG(STRUCT(
      x.source_name AS source_name,
      x.source_record_id AS source_record_id,
      x.matched_key_type AS matched_key_type,
      x.source_release AS source_release,
      x.manifest_uri AS manifest_uri,
      x.source_file_uri AS source_file_uri
    )) AS source_crossrefs
  FROM aliases AS a
  JOIN xref_dedup AS x ON x.identity_lookup_key = a.lookup_key
  GROUP BY a.identity_set_key
)
SELECT
  CONCAT('T', terpene_size_code, FORMAT('%06d', terpene_size_number)) AS terpene_id,
  identity_set_key,
  CASE
    WHEN STARTS_WITH(identity_set_key, 'inchi:') THEN 'standard_inchi'
    WHEN STARTS_WITH(identity_set_key, 'inchikey:') THEN 'inchikey'
    WHEN STARTS_WITH(identity_set_key, 'smiles:') THEN 'smiles_fallback'
  END AS identity_key_type,
  inchi,
  inchikey,
  smiles,
  molecular_formula,
  carbon_count,
  CASE
    WHEN carbon_count = 10 THEN 'monoterpene (C10)'
    WHEN carbon_count = 15 THEN 'sesquiterpene (C15)'
    WHEN carbon_count = 20 THEN 'diterpene (C20)'
    WHEN carbon_count = 25 THEN 'sesterterpene (C25)'
    WHEN carbon_count = 30 THEN 'triterpene (C30)'
    WHEN carbon_count = 40 THEN 'tetraterpene (C40)'
    WHEN carbon_count IS NULL THEN 'unknown'
    ELSE 'other carbon count'
  END AS terpene_size_class,
  source_memberships,
  source_record_ids,
  classification_statuses,
  classification_evidence,
  source_releases,
  manifest_uris,
  source_file_uris,
  IFNULL(
    r.source_crossrefs,
    ARRAY<STRUCT<
      source_name STRING,
      source_record_id STRING,
      matched_key_type STRING,
      source_release STRING,
      manifest_uri STRING,
      source_file_uri STRING
    >>[]
  ) AS source_crossrefs,
  CURRENT_TIMESTAMP() AS generated_at
FROM classified_ordered AS g
LEFT JOIN ref_groups AS r USING (identity_set_key);
