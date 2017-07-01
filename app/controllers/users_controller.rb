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
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect "/"
    else
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect "/home"
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
