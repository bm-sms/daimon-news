class AddPublicParticipantPageEnabledToSites < ActiveRecord::Migration
  def change
    add_column :sites, :public_participant_page_enabled, :boolean, null: false, default: false
  end
end
