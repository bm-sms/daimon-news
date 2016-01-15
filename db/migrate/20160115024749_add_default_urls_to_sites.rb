class AddDefaultUrlsToSites < ActiveRecord::Migration
  def change
    change_column :sites, :js_url,  :string, default: "themes/default/application", null: false
    change_column :sites, :css_url, :string, default: "themes/default/application", null: false
  end
end
