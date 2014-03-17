class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|

      t.string :name
      t.string :description
      
      t.timestamps
    end

    add_index :parts, :id
  end
end
