-- Versioned old-to-new crosswalk for the carbon-prefixed T# remap.
-- Create the pre-remap snapshot before replacing the identity table.
CREATE OR REPLACE TABLE
  `terpedia-489015.terpedia_core.terpene_id_crosswalk_20260904` AS
SELECT
  old_t.terpene_id AS previous_terpene_id,
  new_t.terpene_id AS terpene_id,
  new_t.identity_set_key,
  new_t.terpene_size_class,
  new_t.carbon_count,
  CURRENT_TIMESTAMP() AS remapped_at
FROM `terpedia-489015.terpedia_core.terpene_identity_set_pre_remap_20260904` AS old_t
JOIN `terpedia-489015.terpedia_core.terpene_identity_set` AS new_t
USING (identity_set_key);
