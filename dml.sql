INSERT INTO petshop.customers (first_name, last_name, age, email, country, postal_code)
SELECT DISTINCT
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code
FROM petshop.mock_data_raw
ON CONFLICT (email) DO NOTHING;


INSERT INTO petshop.customer_pets (customer_id, pet_type, pet_name, pet_breed)
SELECT
    c.customer_id,
    md.customer_pet_type,
    md.customer_pet_name,
    md.customer_pet_breed
FROM petshop.mock_data_raw md
JOIN petshop.customers c
  ON md.customer_email = c.email
WHERE md.customer_pet_name IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM petshop.customer_pets cp
     WHERE cp.customer_id = c.customer_id
       AND cp.pet_name = md.customer_pet_name
  );


INSERT INTO petshop.sellers (first_name, last_name, email, country, postal_code)
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM petshop.mock_data_raw
ON CONFLICT (email) DO NOTHING;


INSERT INTO petshop.suppliers (name, contact, email, phone, address, city, country)
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM petshop.mock_data_raw
ON CONFLICT (name) DO NOTHING;

INSERT INTO petshop.stores (name, location, city, state, country, phone, email)
SELECT DISTINCT
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM petshop.mock_data_raw
ON CONFLICT (name) DO NOTHING;


INSERT INTO petshop.product_categories (name)
SELECT DISTINCT product_category
FROM petshop.mock_data_raw
ON CONFLICT (name) DO NOTHING;

INSERT INTO petshop.products (
    name, category_id, price, weight, color, size, brand,
    material, description, rating, reviews, release_date, expiry_date
)
SELECT DISTINCT
    md.product_name,
    pc.category_id,
    md.product_price,
    md.product_weight,
    md.product_color,
    md.product_size,
    md.product_brand,
    md.product_material,
    md.product_description,
    md.product_rating,
    md.product_reviews,
    md.product_release_date,
    md.product_expiry_date
FROM petshop.mock_data_raw md
JOIN petshop.product_categories pc
  ON md.product_category = pc.name
ON CONFLICT (name) DO NOTHING;


INSERT INTO petshop.sales_facts (
    sale_date, customer_id, seller_id,
    supplier_id, store_id, product_id,
    quantity, total_price
)
SELECT
    md.sale_date,
    c.customer_id,
    s.seller_id,
    sp.supplier_id,
    st.store_id,
    p.product_id,
    md.sale_quantity,
    md.sale_total_price
FROM petshop.mock_data_raw md
JOIN petshop.customers c
  ON md.customer_email = c.email
JOIN petshop.sellers s
  ON md.seller_email = s.email
JOIN petshop.suppliers sp
  ON md.supplier_name = sp.name
JOIN petshop.stores st
  ON md.store_name = st.name
JOIN petshop.products p
  ON md.product_name = p.name
;
