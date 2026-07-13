SELECT 
-- id
	c.customer_id,
	c.customer_unique_id,
	o.order_id,
	i.order_item_id,
	s.seller_id,
	pr.product_id,
	r.review_id,

	i.price,
	i.freight_value,

	c.customer_city,
	c.customer_state,
	s.seller_city,
	s.seller_state,

	o.order_status,
	CASE
		WHEN o.order_status != 'delivered' THEN NULL
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date 
		THEN TRUE
		ELSE FALSE
	END AS timely_delivery,
	
	o.order_purchase_timestamp,
	o.order_approved_at,
	o.order_delivered_carrier_date,
	o.order_delivered_customer_date,
	o.order_estimated_delivery_date,
	i.shipping_limit_date,

	p.payment_sequential,
	p.payment_type,
	p.payment_installments,
	p.payment_value,

	pr.product_category_name,
	pr.product_name_lenght,
	pr.product_description_lenght,
	pr.product_photos_qty,
	pr.product_weight_g,
	pr.product_length_cm,
	pr.product_height_cm,
	pr.product_width_cm,

	r.review_score,
	r.review_comment_title,
	r.review_comment_message,
	r.review_creation_date,
	r.review_answer_timestamp,

	c.customer_zip_code_prefix,
	s.seller_zip_code_prefix
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
INNER JOIN reviews r ON r.order_id = o.order_id
INNER JOIN order_payments p ON p.order_id = o.order_id
INNER JOIN order_items i ON i.order_id = o.order_id
INNER JOIN products pr ON pr.product_id = i.product_id
INNER JOIN sellers s ON s.seller_id = i.seller_id