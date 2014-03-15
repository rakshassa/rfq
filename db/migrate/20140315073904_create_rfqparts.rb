class CreateRfqparts < ActiveRecord::Migration
  def change
    create_table :rfqparts do |t|
      t.integer :rfqform_id
      t.integer :part_number
      t.string :revision
      t.integer :qty
      t.string :units


      t.timestamps
    end

    add_index :rfqparts, :rfqform_id
  end
end
