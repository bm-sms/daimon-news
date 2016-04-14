class CreateSerials < ActiveRecord::Migration
  def change
    create_table :serials do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :slug, null: false

      t.references :site, index: true, foreign_key: true, null: false
      t.index [:site_id, :slug], unique: true

      t.timestamps null: false
    end
  end
end
