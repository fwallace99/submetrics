class CreateAltSubs < ActiveRecord::Migration[5.1]
  def change
    create_table( :subscriptions, options: 'CHARSET=utf8') do |t|
      t.bigint :subscription_id
      t.bigint :shop_id
      t.bigint :address_id
      t.bigint :customer_id,  index: true, foreign_key: true
      t.datetime :created_at
      t.datetime :updated_at, :null => true
      t.datetime :next_charge_scheduled_at
      t.datetime :cancelled_at, :null => true
      t.string :product_title
      t.string :variant_title
      t.decimal :price
      t.integer :quantity
      t.string :status
      t.bigint :shopify_product_id
      t.string :order_interval_unit
      t.integer :order_interval_frequency
      t.integer :charge_interval_frequency
      t.string :cancellation_reason
      t.integer :order_day_of_month
      t.integer :oder_day_of_week
      t.text :properties
      t.string :sku
      t.bigint :shopify_variant_id
      end
  end
end
