class AddBaseHueToSites < ActiveRecord::Migration
  def change
    add_column :sites, :base_hue, :integer
  end
end
