class RecreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image, null: false

      t.timestamps null: false
    end
  end
end
