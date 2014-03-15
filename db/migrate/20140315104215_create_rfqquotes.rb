class CreateRfqquotes < ActiveRecord::Migration
  def change
    create_table :rfqquotes do |t|
      t.integer :rfqform_id
      t.integer :vendor_id
      t.integer :part_id

      t.string :parts_note
      t.float :unit_price
      t.boolean :no_quote

      t.string :quote_note
      t.string :quote_number
      t.date :quote_date
      t.string :submitted_by

      t.string :feedback

      t.integer :status

      t.timestamps
    end
  end
end
