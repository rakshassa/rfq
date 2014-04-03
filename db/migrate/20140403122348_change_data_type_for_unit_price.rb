class ChangeDataTypeForUnitPrice < ActiveRecord::Migration
  def self.up
   change_column :rfqquote_eaus, :unit_price, :decimal, :precision => 14, :scale => 2
  end
  def self.down
   change_column :rfqquote_eaus, :unit_price, :integer
  end
end
