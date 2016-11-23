class AddIndexToPickupPost < ActiveRecord::Migration
  def change
    add_index :pickup_posts, [:site_id, :order]
  end
end
