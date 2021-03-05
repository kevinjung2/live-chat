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
    redirect "/conversations"
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
