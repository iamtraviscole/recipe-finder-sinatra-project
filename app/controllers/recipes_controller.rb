class RecipesController < ApplicationController

  get '/recipes' do #all recipes
    redirect_if_not_logged_in
    @recipes = Recipe.all
    erb :"recipes/index"
  end

  get '/recipes/new' do #new recipe
    redirect_if_not_logged_in
    @ingredients = Ingredient.all
    erb :"recipes/new"
  end

  get '/recipes/:id' do #show recipe
    redirect_if_not_logged_in
    @recipe = Recipe.find_by(id: params[:id])
    erb :"recipes/show"
  end

  get '/recipes/:id/edit' do #edit recipe form
    redirect_if_not_logged_in
    @recipe = Recipe.find_by(id: params[:id])
    @recipe_ingredients = @recipe.ingredients
    @ingredients = Ingredient.all
    erb :"recipes/edit"
  end

  get '/recipes/:id/delete' do #delete recipe
    redirect_if_not_logged_in
    this_recipe = Recipe.find_by(id: params[:id])
    if current_user.recipes.ids.include?(this_recipe.id)
      current_user.recipes.delete(this_recipe)
      redirect "/home"
    else
      flash[:message] = "You can only delete your own recipes."
      redirect "/home"
    end
  end

  post '/recipes' do #new recipe form action
    redirect_if_not_logged_in
    if params[:recipe][:name] != ""
      @recipe = Recipe.new(params[:recipe])

      params[:ingredients].each do |ingredient_name|
        if ingredient_name != ""
          @recipe.ingredients << Ingredient.find_or_create_by(name: ingredient_name)
        end
      end

      @recipe.save
      current_user.recipes << @recipe
      redirect "/recipes/#{@recipe.id}"
    else
      flash[:message] = "Recipe name required."
      redirect "/recipes/new"
    end
  end

  patch '/recipes/:id' do #recipe edit form action
    redirect_if_not_logged_in
    @recipe = Recipe.find_by(id: params[:id])
    if current_user.recipes.ids.include?(@recipe.id)
      @recipe.update(params[:recipe])
      @recipe.ingredients.clear

      params[:ingredients].each do |ingredient_name|
        if ingredient_name != ""
          @recipe.ingredients << Ingredient.find_or_create_by(name: ingredient_name)
        end
      end

      @recipe.save
      redirect "/recipes/#{@recipe.id}"
    else
      flash[:message] = "You can only edit your own recipes."
      redirect "/home"
    end
  end

end
