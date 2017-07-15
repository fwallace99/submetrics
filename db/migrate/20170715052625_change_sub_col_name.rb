class ChangeSubColName < ActiveRecord::Migration[5.1]
  def change
    rename_column :subscriptions, :oder_day_of_week, :order_day_of_week
  end
end
