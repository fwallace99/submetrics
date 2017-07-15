class CreateStoreOrders < ActiveRecord::Migration[5.1]
  def change
    create_table( :store_orders, options: 'CHARSET=utf8') do |t|

      t.bigint :order_id
      t.string :transaction_id
      t.string :charge_status
      t.string :payment_processor
      t.integer :address_is_active
      t.string :status
      t.string :type
      t.bigint :charge_id, index: true, foreign_key: true
      t.bigint :address_id
      t.bigint :shopify_id
      t.string :shopify_order_id
      t.bigint :shopify_order_number
      t.string :shopify_cart_token
      t.datetime :shipping_date
      t.datetime :scheduled_at
      t.datetime :shipped_date
      t.datetime :processed_at
      t.bigint :customer_id, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.integer :is_prepaid
      t.datetime :created_at
      t.datetime :updated_at
      t.string :email
      t.text :line_items
      t.string :variant_title
      t.bigint :subscription_id, index: true, foreign_key: true
      t.integer :quantity
      t.bigint :shopify_product_id
      t.text :properties
      t.decimal :total_price
      t.text :shipping_address
      t.text :billing_address

      
    

    end

  end
end
