require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'dinosaurus'


configure do 
	enable :sessions
end


Dinosaurus.configure do |config|
	config.api_key = '98eb24a061cfcf3c760b2e8a908bebe3'
end


get '/' do
	session[:essays] ||locals= []
	# newword = Dinosaurus.lookup('sun')
	erb :'index.html', :locals => {:essays => session[:essays]}
end

post '/' do  # grabbing stuff from the form
	session[:essays] ||= []
	output = Dinosaurus.lookup(params[:input])
	array = session[:essays].unshift(output.synonyms)
	specific = array[0]
	random = specific[rand(specific.length)]
	random ||= params[:input]
	erb :'index.html', :locals => {:essays => session[:essays], :random => random}
end