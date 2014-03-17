class CreateVendorContacts < ActiveRecord::Migration
  def change
    create_table :vendor_contacts do |t|
      t.integer :vendor_id
      t.string :name
      t.string :email

      t.timestamps
    end

    add_index :vendor_contacts, :id
  end
end
