class CreateDaimonNewsAdminPosts < ActiveRecord::Migration
  def change
    create_table :daimon_news_admin_posts do |t|
      t.string :title
      t.text :body
      t.references :daimon_news_admin_site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
