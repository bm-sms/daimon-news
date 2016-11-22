class CreatePickupPosts < ActiveRecord::Migration
  def change
    create_table :pickup_posts do |t|
      t.references :site, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
      t.integer :order

      t.timestamps null: false
    end
  end
end
