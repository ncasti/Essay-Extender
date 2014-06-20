require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'dinosaurus'


configure do 
	enable :sessions
end


Dinosaurus.configure do |config|
	config.api_key = '800e8967fc19dd1f3ed95f4e43b63a78'
end

before do
	session[:essays] ||= []
end


get '/' do
	# newword = Dinosaurus.lookup('sun')
	erb :'index.html', :locals => {:essays => session[:essays], 
									:translation => @translation,
									:input => @input,
									:chardiff => @chardiff}
end


post '/' do 
	@input = params[:input]
	@translation = translate(params[:input])
	session[:essays].unshift(@translation)
	@chardiff = @chardiff
	erb :'index.html', :locals => {:essays => session[:essays], 
									:translation => @translation,
									:input => @input,
									:chardiff => @chardiff}
end




def translate(text)


	text_array = text.split(" ")

	new_words = []

	text_array.each do |word|
		diff_words = []
		exceptions = ["i","am","a","an","as","you","him","us","he","she","they","we","sr","jr","ms","mr","mrs","her","his","the","it","to","be","what","which","who","is","was","where","why","in","on","at","are"]
		symbolselector = word.tr('A-Za-z', '') #selecting symbols in words
		wordnosymbol = word.delete symbolselector #deletes symbols from word and saves it in a variable

		

			output = Dinosaurus.lookup(wordnosymbol) #looks up the word without the symbol in the dictionary
			sy1 = output.synonyms # is the array synonyms of the word without the symbolz
			sy1.delete_if {|word| word.length < wordnosymbol.length}
			
			if sy1 == [] #if the word without symbol does not exist in the thesaurus
				pushing = word #what we are pushing

			else #i.e., if the word without the symbols does exist in the dictionary
				if (exceptions.include? wordnosymbol.downcase) == true
					pushing = word
				elsif wordnosymbol[0] == wordnosymbol[0].upcase
					pushing = word
				else
					sy2 = sy1[rand(sy1.length)] #sy2 is the synonym of the word without the symbols
					pushing = word.gsub(/#{wordnosymbol}/, sy2)
					#diff_words.push(output.synonyms)
				end
			end
		#new_words.push(diff_words[0][rand(diff_words[0].length)])
		new_words.push(pushing) #new thing i added

		
	end
	s = new_words.join(" ")
	stopA = s.enum_for(:scan, ". ").map { Regexp.last_match.begin(0) } #an array of the indexes of . /
	questionA = s.enum_for(:scan, "? ").map { Regexp.last_match.begin(0) }
	exclamationA = s.enum_for(:scan, "! ").map { Regexp.last_match.begin(0) }



	firstA = []
	stopA.each do |item|
		firstA.push(item + 2)
	end

	questionA.each do |item|
		firstA.push(item + 2)
	end

	exclamationA.each do |item|
		firstA.push(item + 2)
	end

	firstA.each do |index|
		s[index] = s[index].upcase
	end

	if s[0] == nil
		s = "<i><p style='color:red;'> What are you doing? Try again. Jesus.</p></i>"
	elsif s[0] != nil
		s[0] = s[0].upcase
		@chardiff = "You have successfully extended your essay by <b style='color:red; font-size:24px;'>" + (s.length - @input.length).to_s + "</b> characters."
	end

	s

end

# arr.each do |word|
# 	old_word = word
# 	word_just_chars = old_word.match('/[A-Za-z]/')[0]
# 	result = my_method
# 	final = old_word.sub(word_just_chars,result)
# end