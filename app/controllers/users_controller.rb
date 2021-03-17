class UsersController < ApplicationController

  # GET: /users -friends page
  get "/users" do
    redirect_if_not_logged_in
    @user = current_user
    @friends = @user.followers
    erb :"/users/index"
  end

  #POST: /users/friend -adds a friend from respose in get /users
  post '/users/friend' do
    if params[:username] == ""
      flash[:message] = "Friends Username field must not be blank."
      redirect :'/users'
    elsif !User.find_by(username: params[:username])
      flash[:message] = "There is no User with that username."
      redirect :'/users'
    else
      current_user.followers << User.find_by(username: params[:username])
      User.find_by(username: params[:username]).followers << current_user
      redirect :'/users'
    end
  end

  # GET: /users/new -also known as signup
  get "/users/new" do
    redirect_if_logged_in
    erb :"/users/new"
  end

  # POST: /users -posts results from /users/new
  post "/users" do
    if User.find_by(username: params[:username])
      flash[:message] = "The username #{params[:username]} is already taked :( please choose a different one."
      redirect :'/users/new'
    elsif params[:username] == "" || params[:password] == ""
      flash[:message] = "Neither the username or password fields can be blank."
      redirect :'users/new'
    else
      user = User.create(username: params[:username], password: params[:password])
      session[:user_id] = user.id
      redirect :"/users/#{user.id}"
    end
  end

  # GET: /users/5 -profile pages
  get "/users/:id" do
    redirect_if_not_logged_in
    if params[:id].to_i == current_user.id
      @friends = current_user.followers
      @conversations = current_user.conversations
      erb :"/users/show"
    elsif !User.find_by(id: params[:id])
      flash[:message] = "User does not exist"
      redirect :"/users/#{current_user.id}"
    elsif User.find_by(id: params[:id]).followers.include?(current_user)
      @user = User.find_by(id: params[:id])
      @friends = @user.followers
      erb :'users/friends'
    else
      @user = User.find_by(id: params[:id])
      erb :'users/not_friends'
    end
  end
  
  # DELETE: /users/5/delete - removes a user(can only be done by the logged in user)
  delete "/users/:id/delete" do
    if current_user == User.find_by(id: params[:id])
      current_user.destroy
      session.clear
      redirect :'/login'
    else
      flash[:message] = "You can only delete your own account"
      redirect "/users"
    end
  end
end
