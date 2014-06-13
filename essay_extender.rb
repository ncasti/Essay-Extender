require 'sinatra'
require 'sinatra/reloader'
require 'pry'

configure do 
	enable :sessions
end

get '/' do
	session[:essays] ||= []
	erb :'index.html', :locals => {:essays => session[:essays]}
end

post '/' do  # grabbing stuff from the form
	session[:essays] ||= []
	output = params[:input]
	session[:essays].push(output)
	erb :'index.html', :locals => {:essays => session[:essays]}
end