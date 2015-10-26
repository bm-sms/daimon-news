class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :site, null: false, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps null: false
    end
  end
end
