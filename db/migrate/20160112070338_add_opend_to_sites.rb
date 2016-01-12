class AddOpendToSites < ActiveRecord::Migration
  def up
    add_column :sites, :opened, :boolean, default: false

    execute 'UPDATE sites SET "opened" = true'

    change_column_null :sites, :opened, false
  end

  def down
    remove_column :sites, :opened
  end
end
