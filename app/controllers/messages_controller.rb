class MessagesController < ApplicationController

  # GET: /messages/new -sends a new message
  get "/messages/new" do
    erb :"/messages/new.html"
  end

  # POST: /messages -posts new message created in /messages/new
  post "/messages" do
    redirect "/messages"
  end

  # GET: /messages/5/edit -allows the user to edit message they have already sent
  get "/messages/:id/edit" do
    erb :"/messages/edit.html"
  end

  # PATCH: /messages/5 -patches changes from /messages/:id/edit
  patch "/messages/:id" do
    redirect "/messages/:id"
  end

  # DELETE: /messages/5/delete -deletes a message (must be user that sent message to delete --possibly add the ability for conversation admins and let them delete as well)
  delete "/messages/:id/delete" do
    redirect "/messages"
  end
end
