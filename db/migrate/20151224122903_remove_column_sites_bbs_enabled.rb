class RemoveColumnSitesBbsEnabled < ActiveRecord::Migration
  def change
    remove_column :sites, :bbs_enabled, :boolean, default: false
  end
end
