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


post '/' do 
	translation = translate(params[:input])
	session[:essays].unshift(translation)

	erb :'index.html', :locals => {:essays => session[:essays], :translation => translation}
end


def translate(text)

	text_array = text.split(" ")

	new_words = []

	text_array.each do |word|
		diff_words = []
		output = Dinosaurus.lookup(word)
		diff_words.push(output.synonyms)
		new_words.push(diff_words[0][rand(diff_words[0].length)])
	end

	new_words.join(" ")

end