class CreateShop < ActiveRecord::Migration[5.1]
  def change
    create_table( :shops, options: 'CHARSET=utf8') do |t|
      t.string :shop_name
      t.string :email
      t.string :password
      t.string :username
      t.string :api_key

    end
    add_index :shops, :shop_name
    add_index :shops, :email
    add_index :shops, :username
  end
end
