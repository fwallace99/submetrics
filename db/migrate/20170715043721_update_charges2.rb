class UpdateCharges2 < ActiveRecord::Migration[5.1]
  def change
    change_table :charges do |t|
      #t.references  :customer, foreign_key: { to_table: :customers }, index: true
      #customer_id_id
      #t.remove_foreign_key customer_id
      end
      


    remove_column :charges, :customer_id_id

  end
end
