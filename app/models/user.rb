class User < ActiveRecord::Base
  enum role: { admin: "admin", site_owner: "site_owner", user: "user" }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
end
