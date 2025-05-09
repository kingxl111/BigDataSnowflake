SET search_path = staging;

COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA.csv' DELIMITER ',' CSV HEADER;
COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA (1).csv'  DELIMITER ',' CSV HEADER;
COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA (2).csv'  DELIMITER ',' CSV HEADER;
COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA (3).csv'  DELIMITER ',' CSV HEADER;
COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA (4).csv'  DELIMITER ',' CSV HEADER;
COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA (5).csv'  DELIMITER ',' CSV HEADER;
COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA (6).csv'  DELIMITER ',' CSV HEADER;
COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA (7).csv'  DELIMITER ',' CSV HEADER;
COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA (8).csv'  DELIMITER ',' CSV HEADER;
COPY staging.mock_data FROM '/docker-entrypoint-initdb.d/data/MOCK_DATA (9).csv'  DELIMITER ',' CSV HEADER;



SET search_path = lab1;


INSERT INTO dim_customer (first_name, last_name, age, email, country, postal_code)
SELECT DISTINCT
  customer_first_name,
  customer_last_name,
  customer_age,
  customer_email,
  customer_country,
  customer_postal_code
FROM staging.mock_data
WHERE customer_email IS NOT NULL;


INSERT INTO dim_seller (first_name, last_name, email, country, postal_code)
SELECT DISTINCT
  seller_first_name,
  seller_last_name,
  seller_email,
  seller_country,
  seller_postal_code
FROM staging.mock_data
WHERE seller_email IS NOT NULL;


INSERT INTO dim_product (name, category, price, weight, color, size, brand, material, description, rating, reviews, release_date, expiry_date)
SELECT DISTINCT
  product_name,
  product_category,
  product_price,
  product_weight,
  product_color,
  product_size,
  product_brand,
  product_material,
  product_description,
  product_rating,
  product_reviews,
  product_release_date,
  product_expiry_date
FROM staging.mock_data
WHERE product_name IS NOT NULL;


INSERT INTO dim_store (name, location, city, state, country, phone, email)
SELECT DISTINCT
  store_name,
  store_location,
  store_city,
  store_state,
  store_country,
  store_phone,
  store_email
FROM staging.mock_data
WHERE store_name IS NOT NULL;


INSERT INTO dim_supplier (name, contact, email, phone, address, city, country)
SELECT DISTINCT
  supplier_name,
  supplier_contact,
  supplier_email,
  supplier_phone,
  supplier_address,
  supplier_city,
  supplier_country
FROM staging.mock_data
WHERE supplier_name IS NOT NULL;


INSERT INTO fact_sales (
  sale_date,
  customer_key,
  seller_key,
  product_key,
  store_key,
  supplier_key,
  quantity,
  total_price
)
SELECT
  m.sale_date,
  c.customer_key,
  s.seller_key,
  p.product_key,
  st.store_key,
  sup.supplier_key,
  m.sale_quantity,
  m.sale_total_price
FROM staging.mock_data AS m
  JOIN dim_customer c
    ON m.customer_email = c.email
  JOIN dim_seller s
    ON m.seller_email = s.email
  JOIN dim_product p
    ON m.product_name = p.name
  JOIN dim_store st
    ON m.store_name = st.name
  JOIN dim_supplier sup
    ON m.supplier_name = sup.name
WHERE
  m.sale_date IS NOT NULL
  AND m.sale_total_price IS NOT NULL
  AND m.sale_quantity > 0;
