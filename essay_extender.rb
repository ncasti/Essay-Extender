require 'sinatra'
require 'sinatra/reloader'
require 'pry'

configure do 
	enable :sessions
end

get '/' do
	sessions[:essays] ||= []
	erb :index, :locals => {:essays => sessions[:essays]}
end

post '/' do  # grabbing stuff from the form
	sessions[:essays] ||= []
	output = params[:input].join(" ")
	sessions[:essays].push(output)
	erb :index, :locals => {:essays => sessions[:essays]}
end