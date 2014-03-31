class AddDueDateToRfqforms < ActiveRecord::Migration
  def change
    add_column :rfqforms, :due_date, :date
  end
end
