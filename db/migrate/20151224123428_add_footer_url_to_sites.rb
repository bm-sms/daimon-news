class AddFooterUrlToSites < ActiveRecord::Migration
  def change
    add_column :sites, :footer_url, :string
  end
end
