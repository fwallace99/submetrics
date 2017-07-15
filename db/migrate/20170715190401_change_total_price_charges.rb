class ChangeTotalPriceCharges < ActiveRecord::Migration[5.1]
  def change
    change_column :charges, :total_price, :decimal, :precision => 10, :scale => 2
  end
end
