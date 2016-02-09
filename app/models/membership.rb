class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
end
