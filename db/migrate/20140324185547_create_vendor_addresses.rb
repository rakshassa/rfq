class CreateVendorAddresses < ActiveRecord::Migration
  def change
    create_table :vendor_addresses do |t|
    	t.integer :vendor_id
    	t.string :address1
    	t.string :address2
    	t.string :city
    	t.string :state
    	t.string :zip
    	t.integer :address_type_id
      t.boolean :primary

      t.timestamps
    end

    add_index :vendor_addresses, :id
    add_index :vendor_addresses, :vendor_id
    
  end
end
