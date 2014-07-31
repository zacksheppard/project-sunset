class AddLastTimeUpdatedToCity < ActiveRecord::Migration
  def change
    add_column :cities, :last_time_updated, :datetime
  end
end
