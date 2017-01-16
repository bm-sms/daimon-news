class AddColumnToSite < ActiveRecord::Migration
  def change
    add_column :sites, :resize_thumb, :boolean, default: false, null: false
  end
end
