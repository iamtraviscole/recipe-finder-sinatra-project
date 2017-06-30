class User < ActiveRecord::Base
  has_many :user_ingredientss
  has_many :ingredients, through: :user_ingredients
  has_many :recipes
end
