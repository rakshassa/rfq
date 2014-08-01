class AddSessionIdToUsers < ActiveRecord::Migration
  def change
    add_column :tlx_users, :session_id, :string, :limit => 50
  end
end
