class AddSnsShareTextToSites < ActiveRecord::Migration
  def change
    add_column :sites, :sns_share_caption, :string
    add_column :sites, :twitter_account,   :string
  end
end
