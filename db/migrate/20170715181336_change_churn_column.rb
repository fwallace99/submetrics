class ChangeChurnColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :metrics, :churn, :decimal, :precision => 10, :scale => 2
  end
end
