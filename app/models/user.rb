class User < ActiveRecord::Base
  has_many :user_ingredients
  has_many :ingredients, through: :user_ingredients
  has_many :recipes

  has_secure_password

  validates :username, :password, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates_format_of :email, :with => /@/

  def what_can_i_make

    results = {
      you_can_make: [],
      you_can_almost_make: []
    }

    if self.ingredients.ids.size >= 1

      user_ingredient_ids = self.ingredients.ids.uniq
      all_ingredient_ids = {}

      Recipe.all.each do |recipe|
        all_ingredient_ids["#{recipe.id}"] = recipe.ingredients.ids
      end

      all_ingredient_ids.each do |recipe_id, ingredient_ids|
        user_ingredient_ids_intersection = user_ingredient_ids & ingredient_ids #array of user ingredients that match recipe ingredients
        if user_ingredient_ids_intersection.size >= 1
          if ingredient_ids.size == user_ingredient_ids_intersection.size
            results[:you_can_make] << Recipe.find_by(id: recipe_id)
          elsif ingredient_ids.size - 2 == user_ingredient_ids_intersection.size || ingredient_ids.size - 1 == user_ingredient_ids_intersection.size
            results[:you_can_almost_make] << {
              recipe: Recipe.find_by(id: recipe_id),
              needed_ingredients: needed_ingredients(ingredient_ids, user_ingredient_ids_intersection)
              }
          end
        end
      end

    end

    results
  end

  def needed_ingredients(ingredient_ids, user_ingredient_ids)
    (ingredient_ids - user_ingredient_ids | user_ingredient_ids - ingredient_ids).map do |ing_id|
      Ingredient.find_by(id: ing_id)
    end
  end

end
