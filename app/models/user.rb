class User < ActiveRecord::Base
  has_many :user_ingredients
  has_many :ingredients, through: :user_ingredients
  has_many :recipes

  has_secure_password

  validates :username, :password, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates_format_of :email, :with => /@/
end
