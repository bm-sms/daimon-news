class AddBreadcrumbsRootNameToSites < ActiveRecord::Migration
  def change
    add_column :sites, :breadcrumbs_root_name, :string, null: false, default: 'Home'
  end
end
