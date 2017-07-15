class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table( :customers, options: 'CHARSET=utf8') do |t|
      t.integer :store_id, index: true, foreign_key: true
      t.string :hash
      t.string :email
      t.string :shopify_customer_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string :first_name
      t.string :last_name
      t.string :billing_last_name
      t.string :billing_first_name
      t.string :billing_address1
      t.string :billing_address2
      t.string :billing_zip
      t.string :billing_city
      t.string :billing_company
      t.string :billing_province
      t.string :billing_country
      t.string :billing_phone
      t.string :processor_type
      t.string :status
     

    end
    #add_index :metrics, :store_id


  end
end
