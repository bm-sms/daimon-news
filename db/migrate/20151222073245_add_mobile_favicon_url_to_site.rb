class AddMobileFaviconUrlToSite < ActiveRecord::Migration
  def change
    add_column :sites, :mobile_favicon_url, :string
  end
end
