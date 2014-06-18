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
	erb :'index.html', :locals => {:essays => session[:essays], :translation => @translation}
end


post '/' do 
	@translation = translate(params[:input])
	session[:essays].unshift(@translation)

	erb :'index.html', :locals => {:essays => session[:essays], :translation => @translation}
end


def translate(text)


	text_array = text.split(" ")

	new_words = []

	text_array.each do |word|
		diff_words = []
		symbolselector = word.tr('A-Za-z', '') #selecting symbols in words
		wordnosymbol = word.delete symbolselector #deletes symbols from word and saves it in a variable
		output = Dinosaurus.lookup(wordnosymbol) #looks up the word without the symbol in the dictionary
		if output.synonyms == [] #if the word without symbol does not exist in the thesaurus
			pushing = word #what we are pushing

		else #i.e., if the word without the symbols does exist in the dictionary
			sy1 = output.synonyms # is the array synonyms of the word without the symbols
			sy2 = sy1[rand(sy1.length)] #sy2 is the synonym of the word without the symbols
			pushing = word.gsub(/#{wordnosymbol}/, sy2)
			#diff_words.push(output.synonyms)
		end
		#new_words.push(diff_words[0][rand(diff_words[0].length)])
		new_words.push(pushing) #new thing i added

		
	end
	s = new_words.join(" ").capitalize
	stopA = s.enum_for(:scan, ". ").map { Regexp.last_match.begin(0) } #an array of the indexes of . /
	#questionA = s.enum_for(:scan, "?").map { Regexp.last_match.begin(0) }


	firstA = []
	stopA.each do |item|
		firstA.push(item + 2)
	end
	firstA.each do |index|
		s[index] = s[index].upcase
	end

	s

end

# arr.each do |word|
# 	old_word = word
# 	word_just_chars = old_word.match('/[A-Za-z]/')[0]
# 	result = my_method
# 	final = old_word.sub(word_just_chars,result)
# end