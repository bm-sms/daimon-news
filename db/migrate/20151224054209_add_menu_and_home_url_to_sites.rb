class AddMenuAndHomeUrlToSites < ActiveRecord::Migration
  def change
    add_column :sites, :menu_url, :string
    add_column :sites, :home_url, :string
  end
end
