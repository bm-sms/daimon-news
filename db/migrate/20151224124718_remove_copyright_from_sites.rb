class RemoveCopyrightFromSites < ActiveRecord::Migration
  def change
    remove_column :sites, :copyright, :string
  end
end
