class CreateVendorContactRoles < ActiveRecord::Migration
  def change
    create_table :vendor_contact_roles do |t|
    	t.integer :vendor_contact_id
    	t.integer :contact_role_id

      t.timestamps
    end
    add_index :vendor_contact_roles, :vendor_contact_id
    add_index :vendor_contact_roles, :contact_role_id
  end
end
