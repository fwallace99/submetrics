# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170717015229) do

  create_table "charges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "address_id"
    t.text "billing_address"
    t.text "client_details"
    t.datetime "created_at"
    t.string "customer_hash"
    t.bigint "customer_id"
    t.bigint "charge_id"
    t.string "first_name"
    t.string "last_name"
    t.text "line_items"
    t.datetime "processed_at"
    t.datetime "scheduled_at"
    t.bigint "shipments_count"
    t.text "shipping_address"
    t.string "shopify_order_id"
    t.string "status"
    t.decimal "total_price", precision: 10, scale: 2
    t.string "type"
    t.datetime "updated_at"
    t.bigint "store_id"
  end

  create_table "customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "store_id"
    t.string "hash"
    t.string "email"
    t.string "shopify_customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name"
    t.string "last_name"
    t.string "billing_last_name"
    t.string "billing_first_name"
    t.string "billing_address1"
    t.string "billing_address2"
    t.string "billing_zip"
    t.string "billing_city"
    t.string "billing_company"
    t.string "billing_province"
    t.string "billing_country"
    t.string "billing_phone"
    t.string "processor_type"
    t.string "status"
    t.index ["store_id"], name: "index_customers_on_store_id"
  end

  create_table "metrics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "store_id"
    t.bigint "total_subscribers"
    t.bigint "cancelled_subscriptions"
    t.decimal "churn", precision: 10, scale: 2
    t.bigint "total_sales"
    t.bigint "total_sales_orders"
    t.bigint "total_recurring_sales"
    t.bigint "total_recurring_orders"
    t.bigint "total_new_sales"
    t.bigint "total_new_orders"
    t.bigint "prev_total_sales"
    t.bigint "prev_sales_orders"
    t.bigint "prev_recurring_sales"
    t.bigint "prev_recurring_orders"
    t.bigint "prev_new_sales"
    t.bigint "prev_new_orders"
    t.bigint "active_subscriptions"
    t.index ["store_id"], name: "index_metrics_on_store_id"
  end

  create_table "shops", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "shop_name"
    t.string "email"
    t.string "password"
    t.string "username"
    t.string "api_key"
    t.index ["email"], name: "index_shops_on_email"
    t.index ["shop_name"], name: "index_shops_on_shop_name"
    t.index ["username"], name: "index_shops_on_username"
  end

  create_table "store_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "order_id"
    t.string "transaction_id"
    t.string "charge_status"
    t.string "payment_processor"
    t.integer "address_is_active"
    t.string "status"
    t.string "type"
    t.bigint "charge_id"
    t.bigint "address_id"
    t.bigint "shopify_id"
    t.string "shopify_order_id"
    t.bigint "shopify_order_number"
    t.string "shopify_cart_token"
    t.datetime "shipping_date"
    t.datetime "scheduled_at"
    t.datetime "shipped_date"
    t.datetime "processed_at"
    t.bigint "customer_id"
    t.string "first_name"
    t.string "last_name"
    t.integer "is_prepaid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email"
    t.text "line_items"
    t.string "variant_title"
    t.bigint "subscription_id"
    t.integer "quantity"
    t.bigint "shopify_product_id"
    t.text "properties"
    t.decimal "total_price", precision: 10
    t.text "shipping_address"
    t.text "billing_address"
    t.bigint "store_id"
  end

  create_table "subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "subscription_id"
    t.bigint "store_id"
    t.bigint "address_id"
    t.bigint "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "next_charge_scheduled_at"
    t.datetime "cancelled_at"
    t.string "product_title"
    t.string "variant_title"
    t.decimal "price", precision: 10
    t.integer "quantity"
    t.string "status"
    t.bigint "shopify_product_id"
    t.string "order_interval_unit"
    t.integer "order_interval_frequency"
    t.integer "charge_interval_frequency"
    t.string "cancellation_reason"
    t.integer "order_day_of_month"
    t.integer "order_day_of_week"
    t.text "properties"
    t.string "sku"
    t.bigint "shopify_variant_id"
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
  end

end
