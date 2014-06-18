arr = ["bad.", "good.", "ugly--"]

arr.each do |word|
	old_word = word
	word_just_chars = old_word.match('/[A-Za-z]/')
	result = my_method
	final = old_word.sub(word_just_chars,result)
end