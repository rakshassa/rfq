class CreateEaus < ActiveRecord::Migration
  def change
    create_table :eaus do |t|
      t.integer :rfqform_id
      t.integer :value, :limit => 8

      t.timestamps
    end

    add_index :eaus, :rfqform_id
  end
end
