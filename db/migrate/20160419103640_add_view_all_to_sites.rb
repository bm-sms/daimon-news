class AddViewAllToSites < ActiveRecord::Migration
  def change
    add_column :sites, :view_all, :boolean, default: false, null: false

    reversible do |dir|
      dir.up do
        execute 'UPDATE sites SET "view_all" = true'
      end
    end
  end
end
