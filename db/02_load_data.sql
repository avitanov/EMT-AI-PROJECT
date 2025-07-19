-- ────────────────────────────────────────────────────────────────
--  02_load_data.sql      (fixed‑width version, 115 spec columns)
-- ────────────────────────────────────────────────────────────────
\echo -> COPYing inverteri.csv into raw_csv …

BEGIN;

------------------------------------------------------------------
-- 1.  Mirror the CSV 1‑to‑1
------------------------------------------------------------------
DROP TABLE IF EXISTS raw_csv;
CREATE UNLOGGED TABLE raw_csv (
    website          text,
    product_name     text,
    price_raw        text,
    image_url        text,
    spec_1   text,  spec_2   text,  spec_3   text,  spec_4   text,
    spec_5   text,  spec_6   text,  spec_7   text,  spec_8   text,
    spec_9   text,  spec_10  text,  spec_11  text,  spec_12  text,
    spec_13  text,  spec_14  text,  spec_15  text,  spec_16  text,
    spec_17  text,  spec_18  text,  spec_19  text,  spec_20  text,
    spec_21  text,  spec_22  text,  spec_23  text,  spec_24  text,
    spec_25  text,  spec_26  text,  spec_27  text,  spec_28  text,
    spec_29  text,  spec_30  text,  spec_31  text,  spec_32  text,
    spec_33  text,  spec_34  text,  spec_35  text,  spec_36  text,
    spec_37  text,  spec_38  text,  spec_39  text,  spec_40  text,
    spec_41  text,  spec_42  text,  spec_43  text,  spec_44  text,
    spec_45  text,  spec_46  text,  spec_47  text,  spec_48  text,
    spec_49  text,  spec_50  text,  spec_51  text,  spec_52  text,
    spec_53  text,  spec_54  text,  spec_55  text,  spec_56  text,
    spec_57  text,  spec_58  text,  spec_59  text,  spec_60  text,
    spec_61  text,  spec_62  text,  spec_63  text,  spec_64  text,
    spec_65  text,  spec_66  text,  spec_67  text,  spec_68  text,
    spec_69  text,  spec_70  text,  spec_71  text,  spec_72  text,
    spec_73  text,  spec_74  text,  spec_75  text,  spec_76  text,
    spec_77  text,  spec_78  text,  spec_79  text,  spec_80  text,
    spec_81  text,  spec_82  text,  spec_83  text,  spec_84  text,
    spec_85  text,  spec_86  text,  spec_87  text,  spec_88  text,
    spec_89  text,  spec_90  text,  spec_91  text,  spec_92  text,
    spec_93  text,  spec_94  text,  spec_95  text,  spec_96  text,
    spec_97  text,  spec_98  text,  spec_99  text,  spec_100 text,
    spec_101 text,  spec_102 text,  spec_103 text,  spec_104 text,
    spec_105 text,  spec_106 text,  spec_107 text,  spec_108 text,
    spec_109 text,  spec_110 text,  spec_111 text,  spec_112 text,
    spec_113 text,  spec_114 text,  spec_115 text
);

COPY raw_csv
    FROM '/import/inverteri.csv'
    WITH (FORMAT csv, HEADER);

------------------------------------------------------------------
-- 2.  Pivot 115 columns → variable‑length list of specs
------------------------------------------------------------------
DROP TABLE IF EXISTS inverteri_product_staging;
CREATE UNLOGGED TABLE inverteri_product_staging AS
WITH expanded AS (
    SELECT
        website,
        product_name,
        -- Strip currency / NBSP etc. and cast to numeric
        trim(trailing '.' from
         replace(                       -- comma → dot
            regexp_replace(price_raw,   -- keep only digits , .
                          '[^0-9.,]',   -- everything else → ''
                          '', 'g'),
            ',', '.')
    )::numeric(12,2)  AS price_local,
        image_url,
        generate_subscripts(specs,1) AS ordinal,
        unnest(specs)                AS spec_text
    FROM (
        SELECT
            website, product_name, price_raw, image_url,
            ARRAY[
              spec_1 ,spec_2 ,spec_3 ,spec_4 ,spec_5 ,spec_6 ,spec_7 ,spec_8 ,
              spec_9 ,spec_10,spec_11,spec_12,spec_13,spec_14,spec_15,spec_16,
              spec_17,spec_18,spec_19,spec_20,spec_21,spec_22,spec_23,spec_24,
              spec_25,spec_26,spec_27,spec_28,spec_29,spec_30,spec_31,spec_32,
              spec_33,spec_34,spec_35,spec_36,spec_37,spec_38,spec_39,spec_40,
              spec_41,spec_42,spec_43,spec_44,spec_45,spec_46,spec_47,spec_48,
              spec_49,spec_50,spec_51,spec_52,spec_53,spec_54,spec_55,spec_56,
              spec_57,spec_58,spec_59,spec_60,spec_61,spec_62,spec_63,spec_64,
              spec_65,spec_66,spec_67,spec_68,spec_69,spec_70,spec_71,spec_72,
              spec_73,spec_74,spec_75,spec_76,spec_77,spec_78,spec_79,spec_80,
              spec_81,spec_82,spec_83,spec_84,spec_85,spec_86,spec_87,spec_88,
              spec_89,spec_90,spec_91,spec_92,spec_93,spec_94,spec_95,spec_96,
              spec_97,spec_98,spec_99,spec_100,spec_101,spec_102,spec_103,
              spec_104,spec_105,spec_106,spec_107,spec_108,spec_109,spec_110,
              spec_111,spec_112,spec_113,spec_114,spec_115
            ] AS specs
        FROM raw_csv
    ) t0
)
SELECT *
FROM expanded
WHERE spec_text IS NOT NULL
  AND spec_text <> '';

COMMIT;

\echo -> inverteri_product_staging ready

-- ❶  Create a “raw” landing table whose columns match frizideri.csv
---------------------------------------------------------------------
DROP TABLE IF EXISTS raw_frizideri_csv;
CREATE UNLOGGED TABLE raw_frizideri_csv (
    website text,
    product_name text,
    price_raw text,
    image_url text,
    spec_1  text, spec_2  text, spec_3  text, spec_4  text, spec_5  text,
    spec_6  text, spec_7  text, spec_8  text, spec_9  text, spec_10 text,
    spec_11 text, spec_12 text, spec_13 text, spec_14 text, spec_15 text,
    spec_16 text, spec_17 text, spec_18 text, spec_19 text, spec_20 text,
    spec_21 text, spec_22 text, spec_23 text, spec_24 text, spec_25 text,
    spec_26 text, spec_27 text, spec_28 text, spec_29 text, spec_30 text,
    spec_31 text, spec_32 text, spec_33 text, spec_34 text, spec_35 text,
    spec_36 text, spec_37 text, spec_38 text, spec_39 text, spec_40 text,
    spec_41 text, spec_42 text, spec_43 text, spec_44 text, spec_45 text,
    spec_46 text, spec_47 text
);

---------------------------------------------------------------------
-- ❷  COPY the fridge CSV  (server‑side, consistent with inverteri)
\echo '-> COPYing frizideri.csv into raw_frizideri_csv …'

COPY raw_frizideri_csv
  FROM '/import/frizideri.csv'
  WITH (FORMAT csv, HEADER, ENCODING 'UTF8');