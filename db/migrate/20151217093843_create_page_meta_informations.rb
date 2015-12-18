class CreatePageMetaInformations < ActiveRecord::Migration
  def change
    create_table :page_meta_informations do |t|
      t.string :path, null: false
      t.string :title
      t.string :description
      t.boolean :noindex
      t.string :keywords
      t.references :site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
