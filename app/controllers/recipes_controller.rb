class RecipesController < ApplicationController

  get '/recipes' do

    erb :"recipes/index"
  end

  get '/recipes/new' do

    erb :"recipes/new"
  end

  get '/recipes/:id' do
    erb :"recipes/show"
  end

  get '/recipes/:id/edit' do

    erb :"recipes/edit"
  end

  post '/recipes' do #new recipe form action

    redirect "/recipes/#{@recipe.id}"
  end

  patch '/recipes/:id' do #recipe edit form action

  end


end
