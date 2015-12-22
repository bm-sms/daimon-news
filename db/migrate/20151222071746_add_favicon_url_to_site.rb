class AddFaviconUrlToSite < ActiveRecord::Migration
  def change
    add_column :sites, :favicon_url, :string
  end
end
