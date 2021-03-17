class MessagesController < ApplicationController

  # POST: /messages -posts new message created in new message form found in the conversation show view
  post "/messages" do
    redirect_if_not_logged_in
    convo = Conversation.find_by(id: params[:conversation])
    #checks that the user is not trying to impersonate someone else.
    if params[:user].to_i != session[:user_id]
      flash[:message] = "You can only send messages from yourself!"
    #checks that the user isnt sending a message to a conversation they are not in.
    elsif !convo || !convo.users.include?(current_user)
      flash[:message] = "You can only send messages to conversations youre apart of!"
      redirect :"/users/#{session[:user_id]}"
    #checks that the user is not sending an empty message
    elsif params[:message] == ""
      flash[:message] = "You cannot send a blank message!"
    #if all other checks fail that the message is created.
    else
      message = Message.create(content: params[:message])
      message.user = user
      message.conversation = convo
      message.save
    end
    #no matter if the message is created or not the user is sent back to the conversation page so they can view their message.
    redirect :"conversations/#{convo.id}"
  end

  # GET: /messages/5/edit -allows the user to edit message they have already sent
  get "/messages/:id/edit" do
    redirect_if_not_logged_in
    @message = Message.find_by(id: params[:id])
    #checks to make sure the message being edited belongs to the current user
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
    #checks to make sure the message was not edited to be blank
    if params[:message] == ""
      flash[:message] = "Message can not be blank."
      redirect :"/messages/#{message.id}/edit"
    #checks to be sure the message belongs to the current user
    elsif message.user != current_user
      flash[:message] = "You can only edit your messages!"
    #if all checks pass the message is edited
    else
      message.update(content: params[:message])
    end
    redirect :"/conversations/#{message.conversation.id}"
  end

  # DELETE: /messages/5/delete -deletes a message (must be user that sent message to delete --possibly add the ability for conversation admins and let them delete as well)
  delete "/messages/:id/delete" do
    #checks that the message belongs to the current user
    if current_user.messages.include?(Message.find_by(id: params[:message].to_i))
      Message.find_by(id: params[:message].to_i).destroy
    else
      flash[:message] = "You can only delete your messages"
    end
    redirect :"/conversations/#{params[:convo]}"
  end
end
