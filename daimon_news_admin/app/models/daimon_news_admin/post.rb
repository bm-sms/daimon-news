module DaimonNewsAdmin
  class Post < ActiveRecord::Base
    belongs_to :site
  end
end
