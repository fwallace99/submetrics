class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table( :charges, options: 'CHARSET=utf8') do |t|

      t.bigint :address_id
      t.text :billing_address
      t.text :client_details
      t.datetime :created_at
      t.string :customer_hash
      t.bigint :customer_id
      t.bigint :charge_id
      t.string :first_name
      t.string :last_name
      t.text :line_items
      t.datetime :processed_at
      t.datetime :scheduled_at
      t.bigint :shipments_count
      t.text :shipping_address
      t.string :shopify_order_id
      t.string :status
      t.decimal :total_price
      t.string :type
      t.datetime :updated_at

     

    end
    #add_index :metrics, :store_id


  end
end
