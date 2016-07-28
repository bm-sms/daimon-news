class AddUniqueIndexToCategoriesOrder < ActiveRecord::Migration
  def up
    execute <<~SQL
      CREATE UNIQUE INDEX index_categories_on_site_id_and_coalesce_ancestry_and_order ON categories (site_id, COALESCE(ancestry, 'NULL'), "order");
    SQL
  end

  def down
    remove_index :categories, name: :index_categories_on_site_id_and_coalesce_ancestry_and_order
  end
end
