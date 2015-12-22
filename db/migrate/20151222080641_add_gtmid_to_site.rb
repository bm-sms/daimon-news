class AddGtmidToSite < ActiveRecord::Migration
  def change
    add_column :sites, :gtm_id, :string
  end
end
