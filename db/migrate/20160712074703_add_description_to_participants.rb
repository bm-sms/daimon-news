class AddDescriptionToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :description, :text
  end
end
