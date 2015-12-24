class AddAdClientAndAdSlotToSites < ActiveRecord::Migration
  def change
    add_column :sites, :ad_client, :string
    add_column :sites, :ad_slot,   :string
  end
end
