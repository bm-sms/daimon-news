class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.string :responsibility, null: false
      t.string :title
      t.string :affiliation
      t.string :photo

      t.references :site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_column :posts, :author_id, :integer
  end
end
