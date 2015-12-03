module DaimonNewsAdmin
  class Post < ActiveRecord::Base
    belongs_to :site, class_name: "::DaimonNewsAdmin::Site", foreign_key: 'daimon_news_admin_site_id'
  end
end
