class CreateMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table( :metrics, options: 'CHARSET=utf8') do |t|
      t.integer :store_id
      t.bigint :total_subscribers
      t.bigint :cancelled_subscriptions
      t.decimal :churn
      t.bigint :total_sales
      t.bigint :total_sales_orders
      t.bigint :total_recurring_sales
      t.bigint :total_recurring_orders
      t.bigint :total_new_sales
      t.bigint :total_new_orders
      t.bigint :prev_total_sales
      t.bigint :prev_sales_orders
      t.bigint :prev_recurring_sales
      t.bigint :prev_recurring_orders
      t.bigint :prev_new_sales
      t.bigint :prev_new_orders

    end
    add_index :metrics, :store_id
    


  end
end
