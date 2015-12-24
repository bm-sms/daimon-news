class DropLinks < ActiveRecord::Migration
  def change
    drop_table :links do |t|
      t.string :text
      t.string :url
      t.integer :order, null: false
      t.references :site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
