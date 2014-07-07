require "sinatra"
require "./lib/database"
require "./lib/contact_database"
require "./lib/user_database"

class ContactsApp < Sinatra::Base
  enable :sessions

  def initialize
    super
    @contact_database = ContactDatabase.new
    @user_database = UserDatabase.new

    jeff = @user_database.insert(username: "Jeff", password: "jeff123")
    hunter = @user_database.insert(username: "Hunter", password: "puglyfe")

    @contact_database.insert(:name => "Spencer", :email => "spen@example.com", user_id: jeff[:id])
    @contact_database.insert(:name => "Jeff D.", :email => "jd@example.com", user_id: jeff[:id])
    @contact_database.insert(:name => "Mike", :email => "mike@example.com", user_id: jeff[:id])
    @contact_database.insert(:name => "Kirsten", :email => "kirsten@example.com", user_id: hunter[:id])
  end

  get "/" do
    if current_user
      erb :logout
    else
      erb :homepage
    end
  end

  get "/login" do
    erb :login
  end

  post "/sessions" do
    @user_database.insert(username: params[:username], password: params[:password])
    session[:id] = find_user[:id] if find_user
    redirect "/"
  end

  get "/logout" do
    erb :logout
  end

  private

  def find_user
    @user_database.select { |user|
      user[:username] == params[:username] && user[:password] == params[:password]
    }.first
  end

  def current_user
    if session[:id]
      @user_database.find(session[:user_id])
    end
  end
end
