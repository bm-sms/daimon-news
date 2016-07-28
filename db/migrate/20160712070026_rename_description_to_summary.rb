class RenameDescriptionToSummary < ActiveRecord::Migration
  def change
    rename_column :participants, :description, :summary
  end
end
