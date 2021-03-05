class ConversationsController < ApplicationController

  # GET: /conversations -lists all current user conversations
  get "/conversations" do
    @user = Helper.current_user
    @conversations = @user.conversations
    erb :"/conversations/index"
  end

  # GET: /conversations/new -shows form to create a new conversation with the new user and selected friends
  get "/conversations/new" do
    @user = Helper.current_user
    @friends = @user.followers
    erb :"/conversations/new"
  end

  # POST: /conversations -posts the new conversation from /conversations/new
  post "/conversations" do
    if params[:users][:username].size == 0 && params[:newfriend][:username] == ""
      flash[:message] = "You can't start a conversation with no-one!!"
      redirect :'/conversations/new'
    elsif params[:newfriend][:username] != "" && !User.find_by(username: params[:newfriend][:username])
      flash[:message] = "The new friend you added does not exist!"
      redirect :'/conversations/new'
    else
      name = ""
      convo = Conversation.new
      convo.users << Helper.current_user
      name += Helper.current_user.username
      if params[:users][:username]
        params[:users][:username].each do |username|
          convo.users << User.find_by(username: username)
          name += username
        end
      end
      if params[:newfriend][:username] != ""
        convo.users << User.find_by(username: params[:newfriend][:username])
        name += params[:newfriend][:username]
      end
      convo.name = name
      convo.save
      redirect "/conversations"
    end
  end

  # GET: /conversations/5 -shows all the messages in a given conversation
  get "/conversations/:id" do
    erb :"/conversations/show.html"
  end

  # GET: /conversations/5/edit -shows the form to allow removal or addition of users to a conversation
  get "/conversations/:id/edit" do
    erb :"/conversations/edit.html"
  end

  # PATCH: /conversations/5 -patches the data from /conversations/:id/edit
  patch "/conversations/:id" do
    redirect "/conversations/:id"
  end

  # DELETE: /conversations/5/delete - removes a conversation(must be in the only user in conversation to delete it --otherwise should just edit and remove current user--)
  delete "/conversations/:id/delete" do
    redirect "/conversations"
  end
end
