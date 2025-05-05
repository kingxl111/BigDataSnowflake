CREATE SCHEMA IF NOT EXISTS petshop;

CREATE TABLE petshop.mock_data_raw (
    id                     BIGINT,
    customer_first_name    TEXT,
    customer_last_name     TEXT,
    customer_age           SMALLINT,
    customer_email         TEXT,
    customer_country       TEXT,
    customer_postal_code   TEXT,
    customer_pet_type      TEXT,
    customer_pet_name      TEXT,
    customer_pet_breed     TEXT,
    seller_first_name      TEXT,
    seller_last_name       TEXT,
    seller_email           TEXT,
    seller_country         TEXT,
    seller_postal_code     TEXT,
    product_name           TEXT,
    product_category       TEXT,
    product_price          NUMERIC,
    product_quantity       INTEGER,
    sale_date              DATE,
    sale_customer_id       BIGINT,
    sale_seller_id         BIGINT,
    sale_product_id        BIGINT,
    sale_quantity          INTEGER,
    sale_total_price       NUMERIC,
    store_name             TEXT,
    store_location         TEXT,
    store_city             TEXT,
    store_state            TEXT,
    store_country          TEXT,
    store_phone            TEXT,
    store_email            TEXT,
    pet_category           TEXT,
    product_weight         NUMERIC,
    product_color          TEXT,
    product_size           TEXT,
    product_brand          TEXT,
    product_material       TEXT,
    product_description    TEXT,
    product_rating         DECIMAL(3,2),
    product_reviews        INTEGER,
    product_release_date   DATE,
    product_expiry_date    DATE,
    supplier_name          TEXT,
    supplier_contact       TEXT,
    supplier_email         TEXT,
    supplier_phone         TEXT,
    supplier_address       TEXT,
    supplier_city          TEXT,
    supplier_country       TEXT
);
-- COPY petshop.mock_data_raw FROM '/path/to/mock_data1.csv' CSV HEADER;

CREATE TABLE petshop.customers (
    customer_id       BIGSERIAL PRIMARY KEY,
    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,
    age               SMALLINT,
    email             VARCHAR(255) UNIQUE NOT NULL,
    country           VARCHAR(100),
    postal_code       VARCHAR(20)
);

CREATE TABLE petshop.customer_pets (
    pet_id            BIGSERIAL PRIMARY KEY,
    customer_id       BIGINT NOT NULL REFERENCES petshop.customers(customer_id),
    pet_type          VARCHAR(50),
    pet_name          VARCHAR(100),
    pet_breed         VARCHAR(100)
);

CREATE TABLE petshop.sellers (
    seller_id         BIGSERIAL PRIMARY KEY,
    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,
    email             VARCHAR(255) UNIQUE NOT NULL,
    country           VARCHAR(100),
    postal_code       VARCHAR(20)
);

CREATE TABLE petshop.suppliers (
    supplier_id       BIGSERIAL PRIMARY KEY,
    name              VARCHAR(255) NOT NULL,
    contact           VARCHAR(100),
    email             VARCHAR(255),
    phone             VARCHAR(50),
    address           TEXT,
    city              VARCHAR(100),
    country           VARCHAR(100)
);

CREATE TABLE petshop.stores (
    store_id          BIGSERIAL PRIMARY KEY,
    name              VARCHAR(255) NOT NULL,
    location          VARCHAR(255),
    city              VARCHAR(100),
    state             VARCHAR(100),
    country           VARCHAR(100),
    phone             VARCHAR(50),
    email             VARCHAR(255)
);

CREATE TABLE petshop.product_categories (
    category_id       BIGSERIAL PRIMARY KEY,
    name              VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE petshop.products (
    product_id        BIGSERIAL PRIMARY KEY,
    name              VARCHAR(255) NOT NULL,
    category_id       BIGINT NOT NULL REFERENCES petshop.product_categories(category_id),
    price             NUMERIC(10,2) NOT NULL,
    weight            NUMERIC(10,3),
    color             VARCHAR(50),
    size              VARCHAR(50),
    brand             VARCHAR(100),
    material          VARCHAR(100),
    description       TEXT,
    rating            DECIMAL(3,2),
    reviews           INTEGER,
    release_date      DATE,
    expiry_date       DATE
);


CREATE TABLE petshop.sales_facts (
    sale_id           BIGSERIAL PRIMARY KEY,
    sale_date         DATE             NOT NULL,
    customer_id       BIGINT           NOT NULL REFERENCES petshop.customers(customer_id),
    seller_id         BIGINT           NOT NULL REFERENCES petshop.sellers(seller_id),
    supplier_id       BIGINT           NOT NULL REFERENCES petshop.suppliers(supplier_id),
    store_id          BIGINT           NOT NULL REFERENCES petshop.stores(store_id),
    product_id        BIGINT           NOT NULL REFERENCES petshop.products(product_id),
    quantity          INTEGER          NOT NULL,
    total_price       NUMERIC(12,2)    NOT NULL
);
