class CreateMetaTags < ActiveRecord::Migration
  def change
    create_table :meta_tags do |t|
      t.string :path, null: false
      t.string :description
      t.boolean :noindex
      t.string :keywords
      t.references :site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
