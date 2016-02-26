class DropAuthors < ActiveRecord::Migration
  def change
    drop_table :authors do |t|
      t.string     :name,       null: false
      t.string     :photo
      t.references :site,       null: false, index: true, foreign_key: true
      t.datetime   :created_at, null: false
      t.datetime   :updated_at, null: false
      t.text       :description
    end
  end
end
