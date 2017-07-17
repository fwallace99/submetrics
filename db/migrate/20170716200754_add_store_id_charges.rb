class AddStoreIdCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :store_id, :bigint
  end
end
