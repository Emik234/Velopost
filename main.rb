require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require_relative './models'

enable :sessions
use Rack::Flash, :sweep => true
set :sessions, true

set :database, "sqlite3:velopost.sqlite3"

get '/' do
	erb :index

end

get '/feed' do
	@post = Post.last
	
	erb :feed


		
end


get '/loginpage' do
	erb :login
	
end


get '/accountsettings' do
	if current_user != nil 
	erb :asettings
	else
		flash[:alert] = "You are not logged in! "
		redirect '/loginpage'
	end 
	
end

get '/profile' do 
	if current_user != nil
		erb :profile
	else 
		flash[:alert] = "You are not logged in! "
		redirect '/loginpage'
	end

end

get '/deleteaccount' do 
	erb :deleteacc
	
end

post '/signin' do
	@user = User.where(email: params[:email]).first

	if @user && @user.password == params[:password]
		flash[:notice] = "You have successfully signed into Velo Post!"
		session[:user_id] = @user.id
		redirect '/feed'
	else 
		flash[:alert] = "Invalid log in information!"
		redirect '/loginpage'
	end


end

post '/signup' do
	@user = User.create(fname: params[:fname], lname: params[:lname], email: params[:email], password: params[:password])
	redirect '/loginpage'

end


get '/deleteaccount' do
	erb :deleteacc
	

end


get '/logout' do
	session[:user_id] = nil
	redirect '/loginpage'
	flash[:alert] = "You have been logged out!"
	
end

post '/updatesettings' do 

	current_user.update(params[:user])
	flash[:notice] = "You have updated your info!"
	redirect '/accountsettings'


end

post '/post' do

	@blogpost = Post.new(blogpost: params[:blogpost])

	if 	@blogpost.save
		flash[:notice] = "Successfully posted!"
		redirect back
		
	else 
		flash[:alert] = "Your post can not be blank!"
		redirect '/feed'
	end


end 

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

def check_login 
	if current_user != nil
		@loginout = "Logout"

	else 
		@loginout = "Login"
	end

end











