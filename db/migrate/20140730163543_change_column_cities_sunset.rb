class ChangeColumnCitiesSunset < ActiveRecord::Migration
  def change
    change_column(:cities, :sunset_utc, :integer)
    change_column(:cities, :timezone, :string)
  end
end
