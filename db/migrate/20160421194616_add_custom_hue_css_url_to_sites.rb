class AddCustomHueCssUrlToSites < ActiveRecord::Migration
  def change
    add_column :sites, :custom_hue_css, :string
  end
end
