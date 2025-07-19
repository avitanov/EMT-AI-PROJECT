/* ================================================================
   01_schema.sql — run first
   ================================================================ */

/* ---------- inverteri ---------- */
CREATE TABLE IF NOT EXISTS inverteri_product (
     id           bigserial PRIMARY KEY,
     website      text    NOT NULL,
     product_name text    NOT NULL,
     price_mkd    numeric,
     image_url    text
);

CREATE TABLE IF NOT EXISTS inverteri_product_specification (
   id         bigserial PRIMARY KEY,           -- separate PK
   product_id bigint      NOT NULL REFERENCES inverteri_product(id) ON DELETE CASCADE,
    spec_key   text        NOT NULL,
    spec_value text        NOT NULL
    );

/* ---------- frizideri ---------- */
CREATE TABLE IF NOT EXISTS frizideri_product (
     id           bigserial PRIMARY KEY,
     website      text    NOT NULL,
     product_name text    NOT NULL,
     price_mkd    numeric,
     image_url    text
);

CREATE TABLE IF NOT EXISTS frizideri_product_specification (
    id         bigserial PRIMARY KEY,
    product_id bigint      NOT NULL REFERENCES frizideri_product(id) ON DELETE CASCADE,
    spec_key   text        NOT NULL,
    spec_value text        NOT NULL
    );
