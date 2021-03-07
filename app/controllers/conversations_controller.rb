class ConversationsController < ApplicationController

  # GET: /conversations -lists all current user conversations
  get "/conversations" do
    redirect_if_not_logged_in
    @user = current_user
    @conversations = @user.conversations
    erb :"/conversations/index"
  end

  # GET: /conversations/new -shows form to create a new conversation with the new user and selected friends
  get "/conversations/new" do
    redirect_if_not_logged_in
    @user = current_user
    @friends = @user.followers
    erb :"/conversations/new"
  end

  # POST: /conversations -posts the new conversation from /conversations/new
  post "/conversations" do
    if !params[:users] && params[:newfriend][:username] == ""
      flash[:message] = "You can't start a conversation with no-one!!"
      redirect :'/conversations/new'
    elsif params[:newfriend][:username] != "" && !User.find_by(username: params[:newfriend][:username])
      flash[:message] = "The new friend you added does not exist!"
      redirect :'/conversations/new'
    else
      name = ""
      convo = Conversation.new
      convo.users << current_user
      name += current_user.username
      if params[:users]
        params[:users][:username].each do |username|
          convo.users << User.find_by(username: username)
          name += ", #{username}"
        end
      end
      if params[:newfriend][:username] != ""
        new_friend = User.find_by(username: params[:newfriend][:username])
        convo.users << new_friend
        current_user.followers << new_friend
        new_friend.followers << current_user
        name += ", #{params[:newfriend][:username]}"
      end
      convo.name = name
      convo.save
      redirect "/conversations/#{convo.id}"
    end
  end

  # GET: /conversations/5 -shows all the messages in a given conversation
  get "/conversations/:id" do
    redirect_if_not_logged_in
    @user = current_user
    @convo = Conversation.find_by(id: params[:id])
    @messages = @convo.messages
    if @convo.users.include?(@user)
      erb :"/conversations/show"
    else
      flash[:message] = "You can only see conversations you are a part of"
      redirect :'/conversations'
    end
  end

  # GET: /conversations/5/edit -shows the form to allow removal or addition of users to a conversation
  get "/conversations/:id/edit" do
    redirect_if_not_logged_in
    @convo = Conversation.find_by(id: params[:id])
    @members = @convo.users
    if @members.include?(current_user)
      erb :"/conversations/edit"
    else
      flash[:message] = "You can only edit conversations you are in!"
      redirect :'/conversations'
    end
  end

  # PATCH: /conversations/5 -patches the data from /conversations/:id/edit
  patch "/conversations/:id" do
    convo = Conversation.find_by(id: params[:id])
    if convo.users.include?(current_user)
      if params[:name] == ""
        flash[:message] = "Conversation name can not be blank."
        redirect :"/conversations"
      elsif params[:users][:username].empty?
        flash[:message] = "Your conversation must have at least one user!"
        redirect :"/conversations"
      else
        users = params[:users][:username].map {|user| User.find_by(username: user)}
        convo.update(name: params[:name], users: users)
      end
    else
      flash[:message] = "You can only edit conversations you are in"
      redirect :'/conversations'
    end
  end

  # DELETE: /conversations/5/delete - removes a conversation(must be in the only user in conversation to delete it --otherwise should just edit and remove current user--)
  delete "/conversations/:id/delete" do
    if Conversation.find_by(id: params[:id]).users.include?(current_user)
      Conversation.find_by(id: params[:id]).destroy
      redirect "/conversations"
    else
      flash[:message] = "You can only delete conversations you are a part of!"
      redirect "/conversations"
    end
  end
end
