class CreateRfqquoteEaus < ActiveRecord::Migration
  def change
    create_table :rfqquote_eaus do |t|
      t.integer :rfqquote_id
      t.integer :eau_id

      t.string :parts_note
      t.float :unit_price
      t.boolean :no_quote
      t.float :tooling
      t.float :nre

      t.string :feedback

      t.timestamps
    end

    add_index :rfqquote_eaus, :rfqquote_id
    add_index :rfqquote_eaus, [:rfqquote_id, :eau_id], :unique => true

  end
end
