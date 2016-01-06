class DropHooks < ActiveRecord::Migration
  def change
    drop_table :hooks do |t|
      t.references :site, foreign_key: true, null: false
      t.string :token, null: false
      t.index  :token, unique: true

      t.timestamps null: false
    end
  end
end
