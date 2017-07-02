class IngredientsController < ApplicationController

  get '/ingredients' do
    @ingredients = Ingredient.all
    erb :"ingredients/index"
  end

  get '/ingredients/new' do
    @ingredients = Ingredient.all
    erb :"ingredients/new"
  end

  get '/ingredients/:id' do
    @ingredient = Ingredient.find_by(id: params[:id])
    erb :"ingredients/show"
  end

  # get '/ingredients/:id/edit' do
  #   @ingredient = Ingredient.find_by(id: params[:id])
  #   erb :"ingredients/edit"
  # end

  get '/ingredients/:id/delete' do
    ingredient = Ingredient.find_by(id: params[:id])
    current_user.ingredients.delete(ingredient)

    redirect "/home"
  end

  post '/ingredients' do #new ingredient form action
    params[:ingredients].each do |ingredient_name|
      if ingredient_name != ""
        current_user.ingredients << Ingredient.find_or_create_by(name: ingredient_name)
      end
    end
    redirect "/ingredients"
  end

  # patch '/ingredients/:id' do #edit ingredient form action
  #
  #   redirect "/ingredients/#{@ingredient.id}"
  # end


end
