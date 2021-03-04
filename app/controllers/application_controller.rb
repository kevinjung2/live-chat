require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  get '/signup' do
    erb :'users/new'
  end

  get '/login' do
    erb :'login'
  end

  get '/logout' do
    session.clear
    redirect :'/login'
  end
end
