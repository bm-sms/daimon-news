class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :sites, through: :memberships

  def editor_of?(site)
    site.memberships.exists?(user: self)
  end
end
