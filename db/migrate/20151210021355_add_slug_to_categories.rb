class AddSlugToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :slug, :string

    add_index :categories, [:slug, :site_id], unique: true

    execute 'UPDATE categories SET slug = name WHERE slug IS NULL' # sloppy work :see_no_evil:

    change_column_null :categories, :slug, false
  end

  def down
    remove_column :categories, :slug
  end
end
