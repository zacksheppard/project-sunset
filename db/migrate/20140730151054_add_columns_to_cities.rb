class AddColumnsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :dst_offset, :integer
    add_column :cities, :raw_offset, :integer
    add_column :cities, :total_offset, :integer
    add_column :cities, :timezone, :string
    add_column :cities, :sunset_utc, :integer

  end
end
