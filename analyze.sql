-- Сколько уникальных sale_id (или комбинаций) в строках?
SELECT COUNT(*)           AS total_rows,
       COUNT(DISTINCT id) AS distinct_ids
  FROM staging.mock_data;

-- пример для электронной почты клиента
SELECT
  COUNT(*)                       AS total,
  COUNT(DISTINCT customer_email) AS unique_emails,
  SUM(CASE WHEN customer_email IS NULL THEN 1 ELSE 0 END) AS null_emails
FROM staging.mock_data;



SELECT COUNT(*) 
  FROM staging.mock_data
 WHERE customer_email IS NULL;

 SELECT customer_email, COUNT(*) 
  FROM lab1.dim_customer
 GROUP BY customer_email
HAVING COUNT(*) > 1;

SELECT 
  (SELECT COUNT(*) FROM staging.mock_data) 
  - (SELECT COUNT(*) FROM lab1.fact_sales) 
  AS missing_rows;

  