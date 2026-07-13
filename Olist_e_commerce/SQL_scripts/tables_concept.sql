-- CREATE DATABASE olist;

CREATE TABLE geolocation(
	geolocation_zip_code_prefix VARCHAR(6),
	geolocation_lat DECIMAL(10, 8),
	geolocation_lng DECIMAL(11, 8),
	geolocation_city VARCHAR(50),
	geolocation_state VARCHAR(3)
);

CREATE INDEX idx_geolocation_code ON geolocation(geolocation_zip_code_prefix);

CREATE TABLE customers(
	customer_id VARCHAR(36) PRIMARY KEY,
	customer_unique_id VARCHAR(36),
	customer_zip_code_prefix VARCHAR(7),
	customer_city VARCHAR(50),
	customer_state VARCHAR(3)
);

CREATE TABLE orders(
	order_id VARCHAR(36) PRIMARY KEY,
	customer_id VARCHAR(36),
	order_status VARCHAR(15), -- следует использовать список возможных состояний
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP,

	CONSTRAINT fk_orders_customer_id
		FOREIGN KEY (customer_id)
		REFERENCES customers(customer_id)
);

CREATE TABLE reviews(
	review_id VARCHAR(36),
	order_id VARCHAR(36),
	review_score INT CHECK (review_score BETWEEN 1 AND 5),
	review_comment_title TEXT DEFAULT NULL,
	review_comment_message TEXT DEFAULT NULL,
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP,

	CONSTRAINT fk_reviews_order_id
		FOREIGN KEY (order_id)
		REFERENCES orders(order_id)
);
-- т.к. review_id имеет повторы, берём индекс а не primary key
CREATE INDEX idx_reviews_review_id ON reviews(review_id);

CREATE TABLE order_payments(
	order_id VARCHAR(36),
	payment_sequential INT,
	payment_type VARCHAR(15), -- на деле следует использовать список возможных значений
	payment_installments INT,
	payment_value DECIMAL(10,2),

	PRIMARY KEY (order_id, payment_sequential),

	CONSTRAINT fk_payments_order_id
		FOREIGN KEY (order_id)
		REFERENCES orders(order_id)
);

CREATE TABLE sellers(
	seller_id VARCHAR(36) PRIMARY KEY,
	seller_zip_code_prefix VARCHAR(6),
	seller_city VARCHAR(50),
	seller_state VARCHAR(3)
);

CREATE TABLE products(
	product_id VARCHAR(36) PRIMARY KEY,
	product_category_name VARCHAR(70),
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT
);

CREATE TABLE order_items(
	order_id VARCHAR(36),
	order_item_id INT,
	product_id VARCHAR(36),
	seller_id VARCHAR(36),
	shipping_limit_date TIMESTAMP,
	price DECIMAL(10,2),
	freight_value DECIMAL(6,2),

	PRIMARY KEY (order_id, order_item_id), 

	CONSTRAINT fk_items_order_id
		FOREIGN KEY (order_id)
		REFERENCES orders(order_id),

	CONSTRAINT fk_items_product_id
		FOREIGN KEY (product_id)
		REFERENCES products(product_id),

	CONSTRAINT fk_items_seller_id
		FOREIGN KEY (seller_id)
		REFERENCES sellers(seller_id)
);