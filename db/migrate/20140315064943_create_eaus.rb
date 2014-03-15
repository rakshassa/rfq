class CreateEaus < ActiveRecord::Migration
  def change
    create_table :eaus do |t|
      t.integer :rfqform_id
      t.integer :value

      t.timestamps
    end

    add_index :eaus, :rfqform_id
  end
end
