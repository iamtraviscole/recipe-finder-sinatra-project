class RecipesController < ApplicationController

  get '/recipes' do

    erb :"recipes/index"
  end

  get '/recipes/new' do
    @ingredients = Ingredient.all
    erb :"recipes/new"
  end

  get '/recipes/:id' do
    erb :"recipes/show"
  end

  get '/recipes/:id/edit' do

    erb :"recipes/edit"
  end

  post '/recipes' do #new recipe form action
    @recipe = Recipe.new(params[:recipe])

    if !params[:ingredients].empty?
      params[:ingredients].each do |ingredient_name|
        @recipe.ingredients << Ingredient.create(name: ingredient_name)
      end

    end

    @recipe.save
    current_user.recipes << @recipe
    current_user.ingredients << @recipe.ingredients
    redirect "/recipes/#{@recipe.id}"
  end

  patch '/recipes/:id' do #recipe edit form action

  end


end
