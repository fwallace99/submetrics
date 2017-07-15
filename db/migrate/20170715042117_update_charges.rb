class UpdateCharges < ActiveRecord::Migration[5.1]
  def change
    change_table :charges do |t|
      t.references  :customer_id, foreign_key: { to_table: :customers }, index: true
      end

    #add_index :charges, :customer_id
    #add_foreign_key :business_hours, :businesses
  end
end
