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

before do
	session[:essays] ||= []
end


get '/' do
	# newword = Dinosaurus.lookup('sun')
	erb :'index.html', :locals => {:essays => session[:essays]}
end

post '/' do  # grabbing stuff from the form
	output = Dinosaurus.lookup(params[:input])
	array = session[:essays].unshift(output.synonyms)
	specific = array[0]
	random ||= params[:input]
	random = specific[rand(specific.length)]
	erb :'index.html', :locals => {:essays => session[:essays], :random => random}
end