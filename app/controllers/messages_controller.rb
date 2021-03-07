class MessagesController < ApplicationController

  # GET: /messages/new -sends a new message
  get "/messages/new" do
    erb :"/messages/new.html"
  end

  # POST: /messages -posts new message created in /messages/new
  post "/messages" do
    convo = Conversation.find_by(id: params[:conversation])
    user = User.find_by(id: session[:user_id])
    if params[:user].to_i != session[:user_id]
      flash[:message] = "You can only send messages from yourself!"
      redirect :"/conversations/#{convo.id}"
    elsif !convo || !convo.users.include?(user)
      flash[:message] = "You can only send messages to conversations youre apart of!"
      redirect :"/users/#{session[:user_id]}"
    elsif params[:message] == ""
      flash[:message] = "You cannot send a blank message!"
      redirect :"/conversations/#{convo.id}"
    else
      message = Message.create(content: params[:message])
      message.user = user
      message.conversation = convo
      message.save
      redirect :"conversations/#{convo.id}"
    end
  end

  # GET: /messages/5/edit -allows the user to edit message they have already sent
  get "/messages/:id/edit" do
    @message = Message.find_by(id: params[:id])
    if @message.user == current_user
      erb :"/messages/edit"
    else
      flash[:message] = "You can only edit your messages"
      redirect :"/conversations/#{@message.conversation.id}"
    end
  end

  # PATCH: /messages/5 -patches changes from /messages/:id/edit
  patch "/messages/:id" do
    message = Message.find_by(id: params[:id])
    if params[:message] == ""
      flash[:message] = "Message can not be blank."
      redirect :"/messages/#{message.id}/edit"
    elsif message.user != current_user
      flash[:message] = "You can only edit your messages!"
    else
      message.update(content: params[:message])
    end
    redirect :"/conversations/#{message.conversation.id}"
  end

  # DELETE: /messages/5/delete -deletes a message (must be user that sent message to delete --possibly add the ability for conversation admins and let them delete as well)
  delete "/messages/:id/delete" do
    if current_user.messages.include?(Message.find_by(id: params[:message].to_i))
      Message.find_by(id: params[:message].to_i).destroy
    else
      flash[:message] = "You can only delete your messages"
    end
    redirect :"/conversations/#{params[:convo]}"
  end
end
