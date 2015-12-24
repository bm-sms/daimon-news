class AddExternalResouceUrlsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :content_header_url, :string
    add_column :sites, :promotion_url,      :string
  end
end
