module DaimonNewsAdmin
  class Site < ActiveRecord::Base
    has_many :daimon_news_admin_posts, class_name: "::DaimonNewsAdmin::Post"
  end
end
