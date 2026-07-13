SELECT COUNT(*) AS total_rows,
	COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls, -- такого не может быть, но для полноты картины возьмем
	COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS customer_unique_id_nulls,
	COUNT(*) FILTER (WHERE customer_zip_code_prefix IS NULL) AS customer_zip_code_nulls,
	COUNT(*) FILTER (WHERE customer_city IS NULL) AS customer_city_nulls,
	COUNT(*) FILTER (WHERE customer_state IS NULL) AS customer_state_nulls
FROM customers;

SELECT COUNT(*) AS total_rows,
	COUNT(*) FILTER (WHERE geolocation_zip_code_prefix IS NULL) AS geo_zip_code_nulls,
	COUNT(*) FILTER (WHERE geolocation_lat IS NULL) AS geo_lat_nulls,
	COUNT(*) FILTER (WHERE geolocation_lng IS NULL) AS geo_lng_nulls,
	COUNT(*) FILTER (WHERE geolocation_city IS NULL) AS geo_city_nulls,
	COUNT(*) FILTER (WHERE geolocation_state IS NULL) AS geo_state_nulls
FROM geolocation;

SELECT COUNT(*) AS total_rows,
	COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_nulls,
	COUNT(*) FILTER (WHERE order_item_id IS NULL) AS order_item_id_nulls,
	COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_nulls,
	COUNT(*) FILTER (WHERE seller_id IS NULL) AS seller_id_nulls,
	COUNT(*) FILTER (WHERE shipping_limit_date IS NULL) AS shipping_limit_date_nulls,
	COUNT(*) FILTER (WHERE price IS NULL) AS price_nulls,
	COUNT(*) FILTER (WHERE freight_value IS NULL) AS freight_value_nulls
FROM order_items;

SELECT COUNT(*) AS total_rows,
	COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_nulls,
	COUNT(*) FILTER (WHERE payment_sequential IS NULL) AS payment_sequential_nulls,
	COUNT(*) FILTER (WHERE payment_type IS NULL) AS payment_type_nulls,
	COUNT(*) FILTER (WHERE payment_installments IS NULL) AS payment_installments_nulls,
	COUNT(*) FILTER (WHERE payment_value IS NULL) AS payment_value_nulls
FROM order_payments;

SELECT COUNT(*) AS total_rows,
	COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_nulls,
	COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
	COUNT(*) FILTER (WHERE order_status IS NULL) AS order_status_nulls,
	COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS order_purchase_nulls,
	COUNT(*) FILTER (WHERE order_approved_at IS NULL) AS order_approved_nulls,
	COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS order_delivered_nulls,
	COUNT(*) FILTER (WHERE order_estimated_delivery_date IS NULL) AS order_estimated_nulls
FROM orders;

UPDATE orders
SET order_approved_at = order_purchase_timestamp
WHERE order_approved_at IS NULL;

UPDATE orders
SET order_delivered_customer_date = order_estimated_delivery_date
WHERE order_delivered_customer_date IS NULL;

SELECT COUNT(*) AS total_rows,
	COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_nulls,
	COUNT(*) FILTER (WHERE product_category_name IS NULL) AS product_cat_name_nulls,
	COUNT(*) FILTER (WHERE product_name_length IS NULL) AS product_name_len_nulls,
	COUNT(*) FILTER (WHERE product_description_length IS NULL) AS product_desc_len_nulls,
	COUNT(*) FILTER (WHERE product_photos_qty IS NULL) AS photos_qty_nulls,
	COUNT(*) FILTER (WHERE product_weight_g IS NULL) AS product_weight_nulls,
	COUNT(*) FILTER (WHERE product_length_cm IS NULL) AS product_length_nulls,
	COUNT(*) FILTER (WHERE product_height_cm IS NULL) AS product_height_nulls,
	COUNT(*) FILTER (WHERE product_width_cm IS NULL) AS product_width_nulls
FROM products;

BEGIN;

DELETE FROM order_items
WHERE product_id IN (
	SELECT product_id
	FROM products
	WHERE product_width_cm IS NULL
	OR product_name_length IS NULL
);

DELETE FROM products
WHERE product_width_cm IS NULL
OR product_name_length IS NULL;

COMMIT;

SELECT COUNT(*) AS total_rows,
	COUNT(*) FILTER (WHERE review_id IS NULL) AS review_id_nulls,
	COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_nulls,
	COUNT(*) FILTER (WHERE review_score IS NULL) AS review_score_nulls,
	COUNT(*) FILTER (WHERE review_comment_title IS NULL) AS comment_title_nulls,
	COUNT(*) FILTER (WHERE review_comment_message IS NULL) AS comment_message_nulls
FROM reviews;

-- Нужно заменить NULL, если будет проводиться Анализ тональностей.

SELECT COUNT(*) AS total_rows,
	COUNT(*) FILTER (WHERE seller_id IS NULL) AS seller_id_nulls,
	COUNT(*) FILTER (WHERE seller_zip_code_prefix IS NULL) AS zip_code_nulls,
	COUNT(*) FILTER (WHERE seller_city IS NULL) AS seller_city_nulls,
	COUNT(*) FILTER (WHERE seller_state IS NULL) AS seller_state_nulls
FROM sellers;
