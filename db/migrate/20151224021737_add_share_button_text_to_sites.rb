class AddShareButtonTextToSites < ActiveRecord::Migration
  def change
    add_column :sites, :share_button_caption_html, :string
    add_column :sites, :twitter_account,           :string
  end
end
