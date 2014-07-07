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
    @users = Database.new

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
    @users.insert(username: params[:username], password: params[:password])
    session[:id] = find_user[:id] if find_user
    redirect '/'
  end

  private

  def find_user(params)
    @users.find { |user|
      user[:username] == params[:username] && user[:password] == params[:password]
    }
  end

  def current_user
    if session[:id]
      @users.find(session[:user_id])
    end
  end
end
