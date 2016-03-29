class RemoveImageUrlsFromSites < ActiveRecord::Migration
  def change
    remove_column :sites, :logo_url,           :string
    remove_column :sites, :favicon_url,        :string
    remove_column :sites, :mobile_favicon_url, :string
  end
end
