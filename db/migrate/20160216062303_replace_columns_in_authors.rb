class ReplaceColumnsInAuthors < ActiveRecord::Migration
  def change
    remove_column :authors, :responsibility, :string
    remove_column :authors, :title, :string
    remove_column :authors, :affiliation, :string
    add_column :authors, :description, :text
  end
end
