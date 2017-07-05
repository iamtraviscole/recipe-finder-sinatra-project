class UsersController < ApplicationController

  get '/home' do #user home page
    if logged_in?
      @user_recipes = current_user.recipes
      @user_ingredients = current_user.ingredients
      @home_active = true
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
      user_ingredients_ids = current_user.ingredients.ids.uniq
      user_recipes = Recipe.all

      user_recipe_ingredient_ids = {}

      user_recipes.each do |recipe|
        user_recipe_ingredient_ids["#{recipe.id}"] = recipe.ingredients.ids
      end

      @you_can_make = {}
      @you_can_almost_make = {}

      user_recipe_ingredient_ids.each do |recipe_id, ingredient_ids|
        user_recipe_ids_intersection = user_ingredients_ids & ingredient_ids

        if ingredient_ids.size == user_recipe_ids_intersection.size && ingredient_ids.size >= 1
          @you_can_make["#{recipe_id}"] = Recipe.find_by(id: recipe_id)
        elsif ingredient_ids.size - 2 || ingredient_ids.size - 1 == user_recipe_ids_intersection.size
          if ingredient_ids.size >= 1 && user_recipe_ids_intersection.size >= 1 then ingredient_ids_needed = ingredient_ids - user_recipe_ids_intersection | user_recipe_ids_intersection - ingredient_ids
            ingredient_ids_needed.each do |id|
              if @you_can_almost_make["#{recipe_id}"]
                @you_can_almost_make["#{recipe_id}"] << Ingredient.find_by(id: id)
              else
                @you_can_almost_make["#{recipe_id}"] = Array.new
                @you_can_almost_make["#{recipe_id}"] << Ingredient.find_by(id: id)

              end
            end
          end
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
        flash[:message] = "Invalid name, email, or password."
        redirect "/signup"
      end
  end

  post '/login' do #login form action
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/home"
    else
      flash[:message] = "Incorrect email or password."
      redirect "/login"
    end
  end


end
