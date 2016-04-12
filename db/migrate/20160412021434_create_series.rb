class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :slug, null: false

      t.references :site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
