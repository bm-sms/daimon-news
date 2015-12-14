class AddMetaInfoToSite < ActiveRecord::Migration
  def change
    change_table :sites do |t|
      t.string :tagline
      t.string :copyright
    end
  end
end
