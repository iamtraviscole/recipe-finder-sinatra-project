require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
      set :public_folder, 'public'
      set :views, 'app/views'
      enable :sessions
      set :session_secret, "secret"
      use Rack::Flash
    end

    get '/' do
      if logged_in?
        redirect '/home'
      else
        erb :index
      end
    end

    helpers do

      def current_user
        @current_user = User.find_by(id: session[:user_id])
      end

      def logged_in?
        !!current_user
      end

      def format_text(text)
        text.gsub("\n", "<br>")
      end

    end

end
