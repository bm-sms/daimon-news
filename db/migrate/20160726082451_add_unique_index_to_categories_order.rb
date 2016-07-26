class AddUniqueIndexToCategoriesOrder < ActiveRecord::Migration
  def change
    add_index :categories, [:site_id, :ancestry, :order], unique: true
  end
end
