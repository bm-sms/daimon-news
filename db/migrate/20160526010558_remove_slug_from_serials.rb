class RemoveSlugFromSerials < ActiveRecord::Migration
  def up
    remove_index :serials, column: [:site_id, :slug], unique: true

    remove_column :serials, :slug, :string, null: false
  end

  def down
    add_column :serials, :slug, :string

    execute <<~SQL
      UPDATE
        serials
      SET
        slug = id
    SQL

    change_column_null :serials, :slug, false

    add_index :serials, [:site_id, :slug], unique: true
  end
end
