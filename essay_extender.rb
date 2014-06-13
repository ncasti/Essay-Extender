require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'dinosaurus'


configure do 
	enable :sessions
end

Dinosaurus.configure do |config|
	config.api_key = 'b833035f63713be4db827676274a8e96'
end


get '/' do
	session[:essays] ||locals= []
	newword = Dinosaurus.lookup('sun')
	erb :'index.html', :locals => {:essays => session[:essays], :newword => newword}
end

post '/' do  # grabbing stuff from the form
	session[:essays] ||= []
	output = params[:input]
	session[:essays].push(output)
	erb :'index.html', :locals => {:essays => session[:essays]}
end