class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :site, index: true, foreign_key: true, null: false
      t.string :name, index: true, null: false
      t.text :description
      t.string :photo

      t.timestamps null: false
    end
  end
end
