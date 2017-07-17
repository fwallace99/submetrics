class ChangeSubscriptionShopId < ActiveRecord::Migration[5.1]
  def change
    rename_column :subscriptions, :shop_id, :store_id
  end
end
