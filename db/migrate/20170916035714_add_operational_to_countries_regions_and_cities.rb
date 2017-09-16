class AddOperationalToCountriesRegionsAndCities < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :operational, :boolean, default: false
    add_column :regions, :operational, :boolean, default: false
    add_column :cities, :operational, :boolean, default: false
  end
end
