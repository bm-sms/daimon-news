class CreatePickupPosts < ActiveRecord::Migration
  def change
    create_table :pickup_posts do |t|
      t.references :site, index: true, foreign_key: true, null: false
      t.references :post, index: true, foreign_key: true, null: false
      t.integer :order

      t.timestamps null: false
    end
    add_index :pickup_posts, [:site_id, :order]
  end
end
