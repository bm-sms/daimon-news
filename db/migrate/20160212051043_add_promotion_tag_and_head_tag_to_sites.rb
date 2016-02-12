class AddPromotionTagAndHeadTagToSites < ActiveRecord::Migration
  def change
    add_column :sites, :promotion_tag, :text
    add_column :sites, :head_tag, :text
  end
end
