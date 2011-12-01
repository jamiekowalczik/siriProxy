require 'tweakSiri'
require 'siriObjectGenerator'
require 'net/smtp'

#######
# This plugin will lookup the user's phrase in a MySQL database and respond
# with either another phrase in the database or run a script on the server.
# 
# Remember to add other plugins to the "start.rb" file if you create them!
######


class SQLRespones < SiriPlugin

	####
	# This gets called every time an object is received from the Guzzoni server
	def object_from_guzzoni(object, connection) 
		object
	end
		
	####
	# This gets called every time an object is received from an iPhone
	def object_from_client(object, connection)
		object
	end
	
	def getDBData(sql)
        	dbh = Mysql.real_connect("localhost", "root", "rootpass", "responses2")
        	query = sql
        	res = dbh.query(query)
        	return res
	end

	def doDBResponses(voice_command)
        	res_responses = getDBData("SELECT * FROM responses")

        	res_responses.each do |row_responses|
                	id = row_responses[0]
                	response_type_id = row_responses[1]
                	response = row_responses[2]

                	res_lookups = getDBData("SELECT * FROM lookups WHERE response_id = #{id}")
			
			matchall = true
			numlookups = 0
                	res_lookups.each do |row_lookups|
                        	lookup = row_lookups[1]
                        	if !voice_command.match(/#{lookup}/i)
                                	matchall = false
                        	end
				numlookups = numlookups + 1
                	end
			if matchall === true && numlookups > 0 
				if response_type_id.to_f == 0.to_f
					return response
				elsif response_type_id.to_f == 1.to_f
					return %x[#{response}]
				end
			end
                	res_lookups.free
        	end
        	res_responses.free
	end
	
	def getDBData1(sql)
                dbh = Mysql.real_connect("localhost", "root", "hccc12pass", "shopping_lists")
                query = sql
                res = dbh.query(query)
                return res
        end

	def createShoppingList(listName)
		res_shopping_lists = getDBData1("INSERT INTO shopping_lists (name) VALUES ('#{listName}')")
		return "Successfully created shopping list named: #{listName}"
	end
	
	def listShoppingLists
		res_shopping_lists = getDBData1("SELECT * FROM shopping_lists")
		allLists = ""
		res_shopping_lists.each do |li|
			allLists << "#{li[1]}\n"
		end
		return allLists
	end

	def deleteShoppingList(listName)
		res_shopping_lists = getDBData1("DELETE FROM shopping_lists WHERE name = '#{listName}'")
		return "Successfully deleted shopping list named: #{listName}"
	end

	def addToShoppingList(listId, listItem)

	end
	
	def deleteFromShoppingList(listId, listItem)

	end
	
	def decipherShoppingListWordage(phrase)
		if phrase.match(/create/i)
			shopping_list_name = phrase.split(/shopping list\s*/i)[1].rstrip
			return createShoppingList(shopping_list_name)
		elsif phrase.match(/list shopping lists/i)
			return listShoppingLists
		elsif (phrase.match(/delete shopping list/i) || phrase.match(/remove shopping list/i))
			shopping_list_name = phrase.split(/shopping list\s*/i)[1].rstrip
			return deleteShoppingList(shopping_list_name)
		elsif phrase.match(/add to shopping list/i)
			shopping_list_name = phrase.split(/shopping list\s*/i)[1].rstrip
			shopping_list_items = phrase.sub("Add to shopping list #{shopping_list_name}","")
			return "List Name: #{shopping_list_name}"
			return "List Items: #{shopping_list_items}"
		end
	
		#phrase2 = "add to shopping list auto stuff carpet and washer fluid and gas and spark plugs"
		#shopping_list_name1 = phrase2.split(/shopping list\s*/i)[1]
		#aList = ""
		#groceries = ""
		#shopping_list_name1.split(/\s/).map do |l|
        	#aList << "#{l} "
        	#if "#{aList}" == "#{shopping_list_name} "
                #groceries = shopping_list_name1.sub(aList,"")
        	#end
		#end
		#groceries.split(/ and /i).map do |g|
        	#puts g
		#end
	end

	def sendEmail(sentFrom, sentFromFriendly, sendTo, sendToFriendly,  msgSubject, msgBody)
		message = <<MESSAGE_END
		From: #{sentFromFriendly} <#{sentFrom}>
		To: #{sendToFriendly} <#{sendTo}>
		Subject: #{msgSubject}

		#{msgBody}
MESSAGE_END

		Net::SMTP.start('localhost') do |smtp|
  			smtp.send_message message, '#{sentFrom}'
		end
	end

	####
	# When the server reports an "unkown command", this gets called. It's useful for implementing commands that aren't otherwise covered
	def unknown_command(object, connection, command)
		object
	end
	
	####
	# This is called whenever the server recognizes speech. It's useful for overriding commands that Siri would otherwise recognize
	def speech_recognized(object, connection, phrase)
		if(phrase.match(/shopping list/i))
			response = decipherShoppingListWordage(phrase)		
			if response != nil
				self.plugin_manager.block_rest_of_session_from_server
                                return generate_siri_utterance(connection.lastRefId, response)
			end
		else
			response = doDBResponses(phrase)
			if response != nil
				self.plugin_manager.block_rest_of_session_from_server
				return generate_siri_utterance(connection.lastRefId, response)
			end
		end
		object
	end
	
end 
