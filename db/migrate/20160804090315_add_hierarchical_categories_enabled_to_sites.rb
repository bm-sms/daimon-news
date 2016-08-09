class AddHierarchicalCategoriesEnabledToSites < ActiveRecord::Migration
  def change
    add_column :sites, :hierarchical_categories_enabled, :boolean, null: false, default: false
  end
end
