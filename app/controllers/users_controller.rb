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
    #checks to make sure that the username field is filled out.
    if params[:username] == ""
      flash[:message] = "Friends Username field must not be blank."
      redirect :'/users'
    #checks to make sure that a user with that name exists.
    elsif !User.find_by(username: params[:username])
      flash[:message] = "There is no User with that username."
      redirect :'/users'
    #checks to make sure the user is not adding themself as a friend.
    elsif User.find_by(username: params[:username]) == current_user.username
      flash[:message] = "You cannot add yourself as a friend."
      redirect :'/users'
    #if all other checks fail than the username field has been filled out and a user with that name exists.
    #so the account is added as a friend.
    else
      #makes the users friends for each other (following and follower)
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

  # POST: /users -posts results from /users/new( where the new user form is handled )
  post "/users" do
    #checks to see if the requested username is available
    if User.find_by(username: params[:username])
      flash[:message] = "The username #{params[:username]} is already taked :( please choose a different one."
      redirect :'/users/new'
    #checks to see if either the username of password feild is blank.
    elsif params[:username] == "" || params[:password] == ""
      flash[:message] = "Neither the username or password fields can be blank."
      redirect :'users/new'
    #if other checks failed than the username is available and the user selected a password so an account is created.
    else
      user = User.create(username: params[:username], password: params[:password])
      session[:user_id] = user.id
      redirect :"/users/#{user.id}"
    end
  end

  # GET: /users/5 -profile pages
  get "/users/:id" do
    redirect_if_not_logged_in
    #checks if the user is looking at their own page
    if params[:id].to_i == current_user.id
      #if they are shows both their friends and conversations
      @friends = current_user.followers
      @conversations = current_user.conversations
      erb :"/users/show"
    #checks to make sure the user they are looking for exists
    elsif !User.find_by(id: params[:id])
      flash[:message] = "User does not exist"
      redirect :"/users/#{current_user.id}"
    #checks to see if they are friends with the user
    elsif User.find_by(id: params[:id]).followers.include?(current_user)
      #if they are friends shows the view currated with information you can see about a friend
      @user = User.find_by(id: params[:id])
      @friends = @user.followers
      erb :'users/friends'
    #if all other checks fail than the user exists, but is not friends with the current user.
    else
      #shows a page that gives an option to add the user as a friend
      @user = User.find_by(id: params[:id])
      erb :'users/not_friends'
    end
  end

  # DELETE: /users/5/delete - removes a user(can only be done by the logged in user)
  delete "/users/:id/delete" do
    #checks to make sure the user being deleted is currently logged in.
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
