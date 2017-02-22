class CreateTopFixedPosts < ActiveRecord::Migration
  def change
    create_table :top_fixed_posts do |t|
      t.references :site, index: true, foreign_key: true, null: false
      t.references :post, index: true, foreign_key: true, null: false
      t.integer :order

      t.timestamps null: false
    end
    add_index :top_fixed_posts, [:site_id, :order]
  end
end
