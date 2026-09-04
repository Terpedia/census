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
)
SELECT
  FORMAT('T%06d', ROW_NUMBER() OVER (ORDER BY identity_set_key)) AS terpene_id,
  identity_set_key,
  CASE
    WHEN STARTS_WITH(identity_set_key, 'inchi:') THEN 'standard_inchi'
    WHEN STARTS_WITH(identity_set_key, 'inchikey:') THEN 'inchikey'
    WHEN STARTS_WITH(identity_set_key, 'smiles:') THEN 'smiles_fallback'
  END AS identity_key_type,
  inchi,
  inchikey,
  smiles,
  source_memberships,
  source_record_ids,
  classification_statuses,
  classification_evidence,
  source_releases,
  manifest_uris,
  source_file_uris,
  CURRENT_TIMESTAMP() AS generated_at
FROM grouped;
