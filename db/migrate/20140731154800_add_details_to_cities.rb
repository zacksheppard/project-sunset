class AddDetailsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :sunset_hour, :integer
    add_column :cities, :sunset_min, :integer
  end
end
