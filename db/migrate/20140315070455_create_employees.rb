class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    add_index :employees, :id
  end
end
