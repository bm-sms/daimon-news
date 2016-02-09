class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :site, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.index %i(site_id user_id), unique: true

      t.timestamps null: false
    end
  end
end
