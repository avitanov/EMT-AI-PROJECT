-- 02_load_data.sql  — landing → staging → final tables

BEGIN;

-------------------------------------------------------------------
-- 1.  Mirror inverteri.csv 1‑to‑1 into a raw table
-------------------------------------------------------------------
DROP TABLE IF EXISTS raw_inverteri_csv;
CREATE UNLOGGED TABLE raw_inverteri_csv (
    website       text,
    product_name  text,
    price_raw     text,
    image_url     text,
    spec_1  text,  spec_2  text,  spec_3  text,  spec_4  text,  spec_5  text,
    spec_6  text,  spec_7  text,  spec_8  text,  spec_9  text,  spec_10 text,
    spec_11 text,  spec_12 text,  spec_13 text,  spec_14 text,  spec_15 text,
    spec_16 text,  spec_17 text,  spec_18 text,  spec_19 text,  spec_20 text,
    spec_21 text,  spec_22 text,  spec_23 text,  spec_24 text,  spec_25 text,
    spec_26 text,  spec_27 text,  spec_28 text,  spec_29 text,  spec_30 text,
    spec_31 text,  spec_32 text,  spec_33 text,  spec_34 text,  spec_35 text,
    spec_36 text,  spec_37 text,  spec_38 text,  spec_39 text,  spec_40 text,
    spec_41 text,  spec_42 text,  spec_43 text,  spec_44 text,  spec_45 text,
    spec_46 text,  spec_47 text,  spec_48 text,  spec_49 text,  spec_50 text,
    spec_51 text,  spec_52 text,  spec_53 text,  spec_54 text,  spec_55 text,
    spec_56 text,  spec_57 text,  spec_58 text,  spec_59 text,  spec_60 text,
    spec_61 text,  spec_62 text,  spec_63 text,  spec_64 text,  spec_65 text,
    spec_66 text,  spec_67 text,  spec_68 text,  spec_69 text,  spec_70 text,
    spec_71 text,  spec_72 text,  spec_73 text,  spec_74 text,  spec_75 text,
    spec_76 text,  spec_77 text,  spec_78 text,  spec_79 text,  spec_80 text,
    spec_81 text,  spec_82 text,  spec_83 text,  spec_84 text,  spec_85 text,
    spec_86 text,  spec_87 text,  spec_88 text,  spec_89 text,  spec_90 text,
    spec_91 text,  spec_92 text,  spec_93 text,  spec_94 text,  spec_95 text,
    spec_96 text,  spec_97 text,  spec_98 text,  spec_99 text,  spec_100 text,
    spec_101 text, spec_102 text, spec_103 text, spec_104 text, spec_105 text,
    spec_106 text, spec_107 text, spec_108 text, spec_109 text, spec_110 text,
    spec_111 text, spec_112 text, spec_113 text, spec_114 text, spec_115 text
);

COPY raw_inverteri_csv
    FROM '/import/inverteri.csv'
    WITH (FORMAT csv, HEADER TRUE, QUOTE '"', ENCODING 'UTF8');

-------------------------------------------------------------------
-- 2.  Mirror frizideri.csv 1‑to‑1 into a raw table
-------------------------------------------------------------------
DROP TABLE IF EXISTS raw_frizideri_csv;
CREATE UNLOGGED TABLE raw_frizideri_csv (
    website       text,
    product_name  text,
    price_raw     text,
    image_url     text,
    spec_1  text,  spec_2  text,  spec_3  text,  spec_4  text,  spec_5  text,
    spec_6  text,  spec_7  text,  spec_8  text,  spec_9  text,  spec_10 text,
    spec_11 text,  spec_12 text,  spec_13 text,  spec_14 text,  spec_15 text,
    spec_16 text,  spec_17 text,  spec_18 text,  spec_19 text,  spec_20 text,
    spec_21 text,  spec_22 text,  spec_23 text,  spec_24 text,  spec_25 text,
    spec_26 text,  spec_27 text,  spec_28 text,  spec_29 text,  spec_30 text,
    spec_31 text,  spec_32 text,  spec_33 text,  spec_34 text,  spec_35 text,
    spec_36 text,  spec_37 text,  spec_38 text,  spec_39 text,  spec_40 text,
    spec_41 text,  spec_42 text,  spec_43 text,  spec_44 text,  spec_45 text,
    spec_46 text,  spec_47 text
);

COPY raw_frizideri_csv
    FROM '/import/frizideri.csv'
    WITH (FORMAT csv, HEADER TRUE, QUOTE '"', ENCODING 'UTF8');

-------------------------------------------------------------------
-- 3.  Load “products” tables (one row per site+name)
-------------------------------------------------------------------
INSERT INTO inverteri_product (website, product_name, price_mkd, image_url)
SELECT DISTINCT ON (website, product_name)
    website,
    product_name,
    trim(trailing '.'
    FROM replace(
    regexp_replace(price_raw,'[^0-9.,]','','g'),
    ',', '.')
    )::numeric(12,2) AS price_mkd,
    image_url
FROM raw_inverteri_csv
ORDER BY website, product_name, price_mkd DESC;

INSERT INTO frizideri_product (website, product_name, price_mkd, image_url)
SELECT DISTINCT ON (website, product_name)
    website,
    product_name,
    trim(trailing '.'
    FROM replace(
    regexp_replace(price_raw,'[^0-9.,]','','g'),
    ',', '.')
    )::numeric(12,2) AS price_mkd,
    image_url
FROM raw_frizideri_csv
ORDER BY website, product_name, price_mkd DESC;

-------------------------------------------------------------------
-- 4.  Explode **every** spec column into its own row, allow duplicates
-------------------------------------------------------------------
INSERT INTO inverteri_product_specification (product_id, spec_text)
SELECT p.id,
       u.spec_text
FROM raw_inverteri_csv AS r
         JOIN inverteri_product AS p
              ON p.website      = r.website
                  AND p.product_name = r.product_name,
     LATERAL unnest(ARRAY[
    r.spec_1,  r.spec_2,  r.spec_3,  r.spec_4,  r.spec_5,
    r.spec_6,  r.spec_7,  r.spec_8,  r.spec_9,  r.spec_10,
    r.spec_11, r.spec_12, r.spec_13, r.spec_14, r.spec_15,
    r.spec_16, r.spec_17, r.spec_18, r.spec_19, r.spec_20,
    r.spec_21, r.spec_22, r.spec_23, r.spec_24, r.spec_25,
    r.spec_26, r.spec_27, r.spec_28, r.spec_29, r.spec_30,
    r.spec_31, r.spec_32, r.spec_33, r.spec_34, r.spec_35,
    r.spec_36, r.spec_37, r.spec_38, r.spec_39, r.spec_40,
    r.spec_41, r.spec_42, r.spec_43, r.spec_44, r.spec_45,
    r.spec_46, r.spec_47, r.spec_48, r.spec_49, r.spec_50,
    r.spec_51, r.spec_52, r.spec_53, r.spec_54, r.spec_55,
    r.spec_56, r.spec_57, r.spec_58, r.spec_59, r.spec_60,
    r.spec_61, r.spec_62, r.spec_63, r.spec_64, r.spec_65,
    r.spec_66, r.spec_67, r.spec_68, r.spec_69, r.spec_70,
    r.spec_71, r.spec_72, r.spec_73, r.spec_74, r.spec_75,
    r.spec_76, r.spec_77, r.spec_78, r.spec_79, r.spec_80,
    r.spec_81, r.spec_82, r.spec_83, r.spec_84, r.spec_85,
    r.spec_86, r.spec_87, r.spec_88, r.spec_89, r.spec_90,
    r.spec_91, r.spec_92, r.spec_93, r.spec_94, r.spec_95,
    r.spec_96, r.spec_97, r.spec_98, r.spec_99, r.spec_100,
    r.spec_101, r.spec_102, r.spec_103, r.spec_104, r.spec_105,
    r.spec_106, r.spec_107, r.spec_108, r.spec_109, r.spec_110,
    r.spec_111, r.spec_112, r.spec_113, r.spec_114, r.spec_115
]) AS u(spec_text)
WHERE u.spec_text IS NOT NULL
  AND u.spec_text <> '';

INSERT INTO frizideri_product_specification (product_id, spec_text)
SELECT p.id,
       u.spec_text
FROM raw_frizideri_csv AS r
         JOIN frizideri_product AS p
              ON p.website      = r.website
                  AND p.product_name = r.product_name,
     LATERAL unnest(ARRAY[
    r.spec_1,  r.spec_2,  r.spec_3,  r.spec_4,  r.spec_5,
    r.spec_6,  r.spec_7,  r.spec_8,  r.spec_9,  r.spec_10,
    r.spec_11, r.spec_12, r.spec_13, r.spec_14, r.spec_15,
    r.spec_16, r.spec_17, r.spec_18, r.spec_19, r.spec_20,
    r.spec_21, r.spec_22, r.spec_23, r.spec_24, r.spec_25,
    r.spec_26, r.spec_27, r.spec_28, r.spec_29, r.spec_30,
    r.spec_31, r.spec_32, r.spec_33, r.spec_34, r.spec_35,
    r.spec_36, r.spec_37, r.spec_38, r.spec_39, r.spec_40,
    r.spec_41, r.spec_42, r.spec_43, r.spec_44, r.spec_45,
    r.spec_46, r.spec_47
]) AS u(spec_text)
WHERE u.spec_text IS NOT NULL
  AND u.spec_text <> '';

COMMIT;
