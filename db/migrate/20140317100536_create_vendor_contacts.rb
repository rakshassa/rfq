class CreateVendorContacts < ActiveRecord::Migration
  def change
    create_table :vendor_contacts do |t|
      t.integer :vendor_id
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end

    add_index :vendor_contacts, :id
    add_index :vendor_contacts, :vendor_id
  end
end
