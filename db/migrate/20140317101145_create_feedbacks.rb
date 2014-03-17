class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :name

      t.timestamps
    end

    add_index :feedbacks, :id
  end
end
