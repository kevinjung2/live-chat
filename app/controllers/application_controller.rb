require './config/environment'

class ApplicationController < Sinatra::Base

  require 'sinatra/flash'

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "46d9f485d124b5091ec14c978048e267fad3ceea0e9968e14e56474f0b69417643a453a4e964c4190f18b4cb74fe1cbe9a65c1ca37bd2549af7eb006aea7fbcd"
  end

  get "/" do
    erb :welcome
  end

  get '/login' do
    erb :'login'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if !user
      flash[:message] = "The username #{params[:username]} was not found. Enter a different username of Sign up instead!"
      redirect :'/login'
    elsif user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect :"/users/#{user.id}"
    else
      flash[:message] = "Incorrect password for the username #{params[:username]}"
      redirect :'/login'
    end
  end

  get '/logout' do
    session.clear
    redirect :'/login'
  end
end
