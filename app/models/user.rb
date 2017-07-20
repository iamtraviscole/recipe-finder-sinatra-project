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
    # ex. results = {
    #   you_can_make: [<#Recipe>, <#Recipe2>, <#Recipe3>],
    #   you_can_almost_make: [
    #     {recipe: Recipe, needed_ingredients: [<#Ingredient>, <#Ingredient2>, <#Ingredient3>]},
    #     {recipe: Recipe2, needed_ingredients: [<#Ingredient6>, <#Ingredient8>, <#Ingredient11>]},
    #   ]
    # }

    if self.ingredients.ids.size >= 1

      user_ingredient_ids = self.ingredients.ids.uniq
      all_ingredient_ids = {}
      # ex. all_ingredient_ids = {
      #   recipe_id1: [1,2,3,4],
      #   recipe_id2: [3,4,7]
      # }

      Recipe.all.each do |recipe|
        all_ingredient_ids["#{recipe.id}"] = recipe.ingredients.ids
      end

      all_ingredient_ids.each do |recipe_id, ingredient_ids|
        user_ingredient_ids_intersection = user_ingredient_ids & ingredient_ids #arry of user ingredients that match recipe ingredients
        if user_ingredient_ids_intersection.size >= 1
          if ingredient_ids.size == user_ingredient_ids_intersection.size
            results[:you_can_make] << Recipe.find_by(id: recipe_id) #adds recipe to you_can_make array in results hash
          elsif ingredient_ids.size - 2 == user_ingredient_ids_intersection.size || ingredient_ids.size - 1 == user_ingredient_ids_intersection.size
            results[:you_can_almost_make] << {recipe: Recipe.find_by(id: recipe_id), needed_ingredients: (ingredient_ids - user_ingredient_ids_intersection | user_ingredient_ids_intersection - ingredient_ids).map {|ing_id| Ingredient.find_by(id: ing_id)}}  #adds recipe to you_can_almost_make and needed ingredients to results hash
          end
        end
      end

    end

    results
  end

end
