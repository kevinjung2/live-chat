class ConversationsController < ApplicationController

  # GET: /conversations
  get "/conversations" do
    erb :"/conversations/index.html"
  end

  # GET: /conversations/new
  get "/conversations/new" do
    erb :"/conversations/new.html"
  end

  # POST: /conversations
  post "/conversations" do
    redirect "/conversations"
  end

  # GET: /conversations/5
  get "/conversations/:id" do
    erb :"/conversations/show.html"
  end

  # GET: /conversations/5/edit
  get "/conversations/:id/edit" do
    erb :"/conversations/edit.html"
  end

  # PATCH: /conversations/5
  patch "/conversations/:id" do
    redirect "/conversations/:id"
  end

  # DELETE: /conversations/5/delete
  delete "/conversations/:id/delete" do
    redirect "/conversations"
  end
end
