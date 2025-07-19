/* ------------------------------------------------------------------
   03_transform.sql
   ------------------------------------------------------------------ */

-- 0. Ensure UNIQUE constraints on (website, product_name)
DO $$
BEGIN
  IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE  conname = 'uq_inverteri_product_site_name') THEN
ALTER TABLE inverteri_product
    ADD CONSTRAINT uq_inverteri_product_site_name
        UNIQUE (website, product_name);
END IF;

  IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE  conname = 'uq_frizideri_product_site_name') THEN
ALTER TABLE frizideri_product
    ADD CONSTRAINT uq_frizideri_product_site_name
        UNIQUE (website, product_name);
END IF;
END$$;


-- ------------------------------------------------------------------
-- 1. INVERTERI → upsert products, map IDs, load specs
-- ------------------------------------------------------------------

-- Build a temp map of (id, website, product_name)
CREATE TEMP TABLE inv_product_map AS
WITH upserted AS (
  INSERT INTO inverteri_product (website,product_name,price_mkd,image_url)
    SELECT DISTINCT ON (website, product_name)
      website, product_name, price_local, image_url
    FROM inverteri_product_staging
    ORDER  BY website, product_name, price_local DESC
  ON CONFLICT (website,product_name) DO
    UPDATE SET price_mkd = EXCLUDED.price_mkd,
               image_url  = EXCLUDED.image_url
  RETURNING id, website, product_name
),
existed AS (
  SELECT id, website, product_name
    FROM inverteri_product
   WHERE (website,product_name)
     IN (SELECT website,product_name
           FROM inverteri_product_staging)
)
SELECT * FROM upserted
UNION ALL
SELECT * FROM existed;


-- Insert the specs, joining through our temp map
INSERT INTO inverteri_product_specification (product_id,spec_key,spec_value)
SELECT DISTINCT ON (m.id, k.spec_key)
    m.id,
    k.spec_key,
    k.spec_value
FROM (
    SELECT
    website,
    product_name,
    COALESCE(NULLIF(trim(split_part(spec_text,':',1)), ''),
    format('spec_%02s', ordinal)) AS spec_key,
    COALESCE(NULLIF(ltrim(split_part(spec_text,':',2)), ''),
    spec_text)                   AS spec_value
    FROM inverteri_product_staging
    WHERE spec_text IS NOT NULL
    AND spec_text <> ''
    ) k
    JOIN inv_product_map m
    USING (website, product_name);


-- ------------------------------------------------------------------
-- 2. FRIZIDERI → upsert products, map IDs, load specs
-- ------------------------------------------------------------------

DO $$
BEGIN
  -- Create the staging table for frizideri
  CREATE UNLOGGED TABLE IF NOT EXISTS frizideri_product_staging AS
  WITH expanded AS (
    SELECT
      website,
      product_name,
      trim(trailing '.' FROM replace(
        regexp_replace(price_raw,'[^0-9.,]','','g'),
        ',', '.'
      ))::numeric(12,2) AS price_local,
      image_url,
      generate_subscripts(specs,1) AS ordinal,
      unnest(specs)               AS spec_text
    FROM (
      SELECT
        website, product_name, price_raw, image_url,
        ARRAY[
          spec_1, spec_2, /* … through … */ spec_47
        ] AS specs
      FROM raw_frizideri_csv
    ) t
  )
SELECT *
FROM expanded
WHERE spec_text IS NOT NULL
  AND spec_text <> '';


-- Build the temp map for frizideri
CREATE TEMP TABLE friz_product_map AS
  WITH upserted AS (
    INSERT INTO frizideri_product (website,product_name,price_mkd,image_url)
      SELECT DISTINCT ON (website, product_name)
        website, product_name, price_local, image_url
      FROM frizideri_product_staging
      ORDER BY website, product_name, price_local DESC
    ON CONFLICT (website,product_name) DO
      UPDATE SET price_mkd = EXCLUDED.price_mkd,
                 image_url  = EXCLUDED.image_url
    RETURNING id, website, product_name
  ),
  existed AS (
    SELECT id, website, product_name
      FROM frizideri_product
     WHERE (website,product_name)
       IN (SELECT website,product_name
             FROM frizideri_product_staging)
  )
SELECT * FROM upserted
UNION ALL
SELECT * FROM existed;


-- Insert the fridge specs
INSERT INTO frizideri_product_specification (product_id,spec_key,spec_value)
SELECT DISTINCT ON (m.id, k.spec_key)
    m.id,
    k.spec_key,
    k.spec_value
FROM (
    SELECT
    website,
    product_name,
    COALESCE(NULLIF(trim(split_part(spec_text,':',1)), ''),
    format('spec_%02s', ordinal)) AS spec_key,
    COALESCE(NULLIF(ltrim(split_part(spec_text,':',2)), ''),
    spec_text)                   AS spec_value
    FROM frizideri_product_staging
    WHERE spec_text IS NOT NULL
    AND spec_text <> ''
    ) k
    JOIN friz_product_map m
    USING (website, product_name);

END$$;
