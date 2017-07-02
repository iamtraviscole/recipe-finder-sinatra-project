class RecipesController < ApplicationController

  get '/recipes' do
    @recipes = Recipe.all
    erb :"recipes/index"
  end

  get '/recipes/new' do
    @ingredients = Ingredient.all
    erb :"recipes/new"
  end

  get '/recipes/:id' do
    @recipe = Recipe.find_by(id: params[:id])
    erb :"recipes/show"
  end

  get '/recipes/:id/edit' do
    @recipe = Recipe.find_by(id: params[:id])
    @recipe_ingredients = @recipe.ingredients
    @ingredients = Ingredient.all
    erb :"recipes/edit"
  end

  post '/recipes' do #new recipe form action
    @recipe = Recipe.new(params[:recipe])

    params[:ingredients].each do |ingredient_name|
      if ingredient_name != ""
        @recipe.ingredients << Ingredient.find_or_create_by(name: ingredient_name)
      end
    end

    @recipe.save
    current_user.recipes << @recipe
    current_user.ingredients << @recipe.ingredients
    redirect "/recipes/#{@recipe.id}"
  end

  patch '/recipes/:id' do #recipe edit form action
    @recipe = Recipe.find_by(id: params[:id])
    @recipe.update(params[:recipe])
    @recipe.ingredients.clear

    params[:ingredients].each do |ingredient_name|
      if ingredient_name != ""
        @recipe.ingredients << Ingredient.find_or_create_by(name: ingredient_name)
      end
    end

    @recipe.save
    redirect "/recipes/#{@recipe.id}"
  end

end
