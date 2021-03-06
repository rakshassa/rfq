class CreateRfqparts < ActiveRecord::Migration
  def change
    create_table :rfqparts do |t|
      t.integer :rfqform_id
      t.integer :part_number
      t.string :revision
      t.float :qty
      t.string :units
      t.text :rfqpartvendors

      #t.attachment :drawing
      t.string :drawing

      t.timestamps
    end

    add_index :rfqparts, :id
    add_index :rfqparts, :rfqform_id
    
  end
end
