module DaimonNewsAdmin
  class Post < ActiveRecord::Base
    belongs_to :daimon_news_admin_site, class_name: "::DaimonNewsAdmin::Site"
  end
end
