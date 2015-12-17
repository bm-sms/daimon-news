class CreateMetaTags < ActiveRecord::Migration
  def change
    create_table :meta_tags do |t|
      t.string :name
      t.string :content
      t.references :site, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
