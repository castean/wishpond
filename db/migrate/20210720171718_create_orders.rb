class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :Crust
      t.string :Flavor
      t.string :Size
      t.integer :Table_No
      t.string :address

      t.timestamps
    end
  end
end
