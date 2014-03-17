class CreateRfqforms < ActiveRecord::Migration
  def change
    create_table :rfqforms do |t|
      t.date :date
      t.string :release_type
      t.string :launch_date
      t.string :ppap
      t.integer :req_by
      t.integer :engineer
      t.text :info
      t.boolean :built

      t.timestamps
    end

    add_index :rfqforms, :id
  end
end
