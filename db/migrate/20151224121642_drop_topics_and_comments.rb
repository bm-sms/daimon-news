class DropTopicsAndComments < ActiveRecord::Migration
  def change
    drop_table :comments do |t|
      t.string :title
      t.text :body
      t.references :topic, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    drop_table :topics do |t|
      t.string :title
      t.text :body
      t.references :site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
