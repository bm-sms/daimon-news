# This migration comes from daimon_news_admin (originally 20151202063923)
class CreateDaimonNewsAdminSites < ActiveRecord::Migration
  def change
    create_table :daimon_news_admin_sites do |t|
      t.string :name,    null: false
      t.string :js_url,  null: false
      t.string :css_url, null: false

      t.timestamps null: false
    end
  end
end
