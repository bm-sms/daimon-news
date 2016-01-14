class RecreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :text, null: false
      t.string :url, null: false
      t.integer :order, null: false
      t.references :site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
