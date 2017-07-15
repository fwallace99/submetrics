create table store_order (
    id BIGINT not null PRIMARY KEY,
    transaction_id varchar(255),
    charge_status varchar(255),
    payment_processor varchar(255),
    address_is_active int,
    status varchar(255),
    type varchar(255),
    charge_id bigint,
    address_id bigint,
    shopify_id bigint,
    shopify_order_id varchar(255),
    shopify_order_number bigint,
    shopify_cart_token varchar(255),
    shipping_date datetime default null,
    scheduled_at datetime default null,
    shipped_date datetime default null,
    processed_at datetime default null,
    customer_id bigint,
    first_name varchar(255),
    last_name varchar(255),
    is_prepaid int,
    created_at datetime default null,
    updated_at datetime default null,
    email varchar(255),
    line_items varchar(1024),
    
    title varchar(255),
    variant_title varchar(255),
    subscription_id bigint,
    quantity int,
    shopify_product_id bigint,
    properties varchar(1024),
    
    total_price decimal(10,2),
    shipping_address varchar(1024),
    
    billing_address varchar(1024)
    

) DEFAULT CHARACTER SET=utf8;

create table charge (
    address_id bigint,
    billing_address varchar(1024),
    client_details varchar(1024), 
    created_at datetime default null,
    customer_hash varchar(255),
    customer_id bigint,
    first_name varchar(255), 
    id bigint primary key,
    last_name varchar(255),
    line_items varchar(2048),
    processed_at datetime,
    scheduled_at datetime,
    shipments_count int,
    shipping_address varchar(1024),
    shopify_order_id varchar(255),
    status varchar(255),
    total_price decimal(10,2),
    type varchar(255),
    updated_at datetime




) DEFAULT CHARACTER SET=utf8;