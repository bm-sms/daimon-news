class AddCategoryTitleFormatToSites < ActiveRecord::Migration
  def change
    add_column :sites, :category_title_format, :string
  end
end
