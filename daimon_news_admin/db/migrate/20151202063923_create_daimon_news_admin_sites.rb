class CreateDaimonNewsAdminSites < ActiveRecord::Migration
  def change
    create_table :daimon_news_admin_sites do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
