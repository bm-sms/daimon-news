class AddViewParticipantsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :view_participants, :boolean, null: false, default: false
  end
end
