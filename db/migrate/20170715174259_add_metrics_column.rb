class AddMetricsColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :metrics, :active_subscriptions, :bigint

  end
end
