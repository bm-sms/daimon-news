class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.text :body
      t.references :topic, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
