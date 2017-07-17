class AddStoreIdOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :store_orders, :store_id, :bigint
  end
end
