class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.boolean :active_rfq
      t.string :phone

      t.timestamps
    end

    add_index :vendors, :id
  end
end
