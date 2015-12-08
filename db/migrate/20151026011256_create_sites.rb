class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name,    null: false
      t.string :js_url,  null: false
      t.string :css_url, null: false

      t.timestamps null: false
    end
  end
end
