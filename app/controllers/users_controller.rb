class UsersController < ApplicationController

  get '/home' do #user home page
    if logged_in?
      @user_recipes = current_user.recipes
      @user_ingredients = current_user.ingredients
      erb :"users/index"
    else
      redirect "/"
    end
  end

  get '/signup' do #user signup page
    if !logged_in?
      erb :"users/new"
    else
      flash[:message] = "You are already logged in."
      redirect "/"
    end
  end

  get '/login' do #user login page
    if !logged_in?
      erb :"users/login"
    else
      flash[:message] = "You are already logged in."
      redirect "/home"
    end
  end

  get '/what-can-i-make' do
    redirect_if_not_logged_in
    if current_user.ingredients.ids.size >= 1
      user_ingredients_ids = current_user.ingredients.ids

      user_recipes = current_user.recipes

      user_recipe_ids = {}

      user_recipes.each do |recipe|
        user_recipe_ids["#{recipe.id}"] = recipe.ingredients.ids
      end

      @you_can_make = {}

      user_recipe_ids.each do |key, value|
        user_recipe_ids_intersection = user_ingredients_ids & value

        if user_ingredients_ids.size == user_recipe_ids_intersection.size
          @you_can_make["#{key}"] = Recipe.find_by(id: key)
        end

      end
    end

    erb :"users/whatcanimake"
  end

  get '/logout' do #user logout link/button
    if session[:user_id] != nil
      session.clear
      flash[:message] = "You have logged out."
      redirect to '/'
    else
      redirect to '/'
    end
  end

  post '/signup' do #signup form action
    @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      if @user.valid?
        session[:user_id] = @user.id
        redirect "/home"
      else
        flash[:message] = "Invalid name, email, or password"
        redirect "/"
      end
  end

  post '/login' do #login form action
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/home"
    else
      flash[:message] = "Incorred email or password."
      redirect "/"
    end
  end


end
