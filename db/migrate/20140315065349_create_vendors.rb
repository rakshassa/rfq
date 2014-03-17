class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.boolean :active_rfq
      t.integer :rfq_contact_id

      t.timestamps
    end

    add_index :vendors, :id
  end
end
