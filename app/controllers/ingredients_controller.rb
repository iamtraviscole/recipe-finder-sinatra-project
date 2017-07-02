class IngredientsController < ApplicationController

  get '/ingredients' do
    redirect_if_not_logged_in
    @ingredients = Ingredient.all
    erb :"ingredients/index"
  end

  get '/ingredients/new' do
    redirect_if_not_logged_in
    @ingredients = Ingredient.all
    erb :"ingredients/new"
  end

  get '/ingredients/:id' do
    redirect_if_not_logged_in
    @ingredient = Ingredient.find_by(id: params[:id])
    erb :"ingredients/show"
  end

  # get '/ingredients/:id/edit' do
  #   @ingredient = Ingredient.find_by(id: params[:id])
  #   erb :"ingredients/edit"
  # end

  get '/ingredients/:id/delete' do
    redirect_if_not_logged_in
    ingredient = Ingredient.find_by(id: params[:id])
    if current_user.ingredients.ids.include?(ingredient.id)
      current_user.ingredients.delete(ingredient)
      redirect "/home"
    else
      flash[:message] = "You can only delete your own ingredients."
      redirect "/home"
    end
  end

  post '/ingredients' do #new ingredient form action
    redirect_if_not_logged_in
    params[:ingredients].each do |ingredient_name|
      if ingredient_name != ""
        current_user.ingredients << Ingredient.find_or_create_by(name: ingredient_name)
      end
    end
    redirect "/home"
  end

  # patch '/ingredients/:id' do #edit ingredient form action
  #
  #   redirect "/ingredients/#{@ingredient.id}"
  # end


end
