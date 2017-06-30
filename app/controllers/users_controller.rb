class UsersController < ApplicationController

  get '/home' do #user home page

    erb :"users/index"
  end

  get '/signup' do #user signup page

    erb :"users/new"
  end

  get '/login' do #user login page

    erb :"users/login"
  end

  get '/logout' do #user logout link/button

    redirect "/"
  end

  post '/signup' do #signup form action

    redirect "/home"
  end

  post '/login' do #login form action

    redirect "/home"
  end


end
