class AddBaseColorToSites < ActiveRecord::Migration
  def change
    add_column :sites, :base_color, :string
  end
end
