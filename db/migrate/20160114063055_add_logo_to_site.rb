class AddLogoToSite < ActiveRecord::Migration
  def change
    add_column :sites, :logo_image, :string
    add_column :sites, :favicon_image, :string
    add_column :sites, :mobile_favicon_image, :string
  end
end
