class CreateRfqpartvendors < ActiveRecord::Migration
  def change
    create_table :rfqpartvendors do |t|
    	t.integer :vendor_id
    	t.integer :rfqpart_id

      t.timestamps
    end

    add_index :rfqpartvendors, :vendor_id
    add_index :rfqpartvendors, :rfqpart_id
  end
end
