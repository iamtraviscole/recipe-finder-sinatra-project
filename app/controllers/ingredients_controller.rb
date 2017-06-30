class IngredientsController < ApplicationController

  get '/ingredients/new' do

    erb :"ingredients/new"
  end

  get '/ingredients/:id' do
    erb :"ingredients/show"
  end

  get '/ingredients/:id/edit' do
    erb :"ingredients/edit"
  end

  post '/ingredients' do #new ingredient form action

    redirect "/ingredients/#{@ingredient.id}"
  end

  patch '/ingredients/:id' do #edit ingredient form action

    redirect "/ingredients/#{@ingredient.id}"
  end


end
