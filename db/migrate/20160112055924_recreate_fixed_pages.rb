class RecreateFixedPages < ActiveRecord::Migration
  def change
    create_table :fixed_pages do |t|
      t.references :site, foreign_key: true, null: false

      t.string :title
      t.text   :body
      t.string :slug, null: false

      t.index %i(site_id slug), unique: true

      t.timestamps null: false
    end
  end
end
