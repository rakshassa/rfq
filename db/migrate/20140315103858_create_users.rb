class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :isTLX
      t.integer :vendor_id

      t.timestamps
    end

    add_index :users, :id
  end
end
