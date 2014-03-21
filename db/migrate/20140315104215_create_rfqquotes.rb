class CreateRfqquotes < ActiveRecord::Migration
  def change
    create_table :rfqquotes do |t|

      t.integer :rfqform_id
      t.integer :vendor_id
      t.integer :part_id
      t.integer :rfqquote_display_id


      t.string :quote_note
      t.string :quote_number
      t.date :quote_date
      t.string :submitted_by
      t.date :valid_till
      t.boolean :exceptions

            
      t.boolean :submitted_to_tlx
      t.date :date_submitted
      t.boolean :feedback_sent
      t.date :date_feedback_sent

      t.timestamps
    end


    add_index :rfqquotes, :id
    add_index :rfqquotes, [:rfqform_id, :vendor_id, :part_id], :unique => true


  end
end
