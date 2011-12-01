#!/usr/bin/env ruby

phrase = "create shopping list auto stuff"
shopping_list_name = phrase.split(/shopping list\s*/i)[1]
puts shopping_list_name
#words_before, shopping_list_name = phrase.split(/\s*shopping list\s*/i).map do |t|
#	t.split(/\s+/)
#end 

phrase2 = "add to shopping list auto stuff carpet and washer fluid and gas and spark plugs"
shopping_list_name1 = phrase2.split(/shopping list\s*/i)[1]
aList = ""
groceries = ""
shopping_list_name1.split(/\s/).map do |l|
	aList << "#{l} "
	if "#{aList}" == "#{shopping_list_name} "
		groceries = shopping_list_name1.sub(aList,"")
	end
end
groceries.split(/ and /i).map do |g|
	puts g
end
