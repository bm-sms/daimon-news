module DaimonNewsAdmin
  class Site < ActiveRecord::Base
    has_many :posts, class_name: "::DaimonNewsAdmin::Post", foreign_key: 'daimon_news_admin_site_id'
  end
end
