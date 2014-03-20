class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :built
      t.string :vendor
      t.integer :program
      t.integer :rfq
      t.string :quote_number

      t.timestamps
    end
  end
end
