class CreateHooks < ActiveRecord::Migration
  def change
    create_table :hooks do |t|
      t.references :site, foreign_key: true, null: false
      t.string :token, null: false
      t.index  :token, unique: true

      t.timestamps null: false
    end
  end
end
