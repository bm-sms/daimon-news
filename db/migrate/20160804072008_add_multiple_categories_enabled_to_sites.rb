class AddMultipleCategoriesEnabledToSites < ActiveRecord::Migration
  def change
    add_column :sites, :multiple_categories_enabled, :boolean, null: false, default: false
  end
end
