class AddBbsEnabledToSites < ActiveRecord::Migration
  def change
    add_column :sites, :bbs_enabled, :boolean, default: false, null: false
  end
end
