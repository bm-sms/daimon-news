class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :text
      t.string :url
      t.integer :order, null: false
      t.references :site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
