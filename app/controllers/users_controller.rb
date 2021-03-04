class UsersController < ApplicationController

  # GET: /users -friends page
  get "/users" do
    erb :"/users/index.html"
  end

  # GET: /users/new -also known as signup
  get "/users/new" do
    erb :"/users/new"
  end

  # POST: /users -posts results from /users/new
  post "/users" do
    redirect "/users"
  end

  # GET: /users/5 -profile pages
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit -edit profile
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5 -patches changes made to a profile from /users/:id/edit
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete - removes a user(can only be done by the logged in user)
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
