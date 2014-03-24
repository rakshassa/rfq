class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|      
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :inactive

      t.timestamps
    end

    add_index :employees, :id
  end
end
