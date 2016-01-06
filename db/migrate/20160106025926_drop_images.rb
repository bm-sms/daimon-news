class DropImages < ActiveRecord::Migration
  def change
    drop_table :images do |t|
      t.string :image, null: false

      t.timestamps null: false
    end
  end
end
