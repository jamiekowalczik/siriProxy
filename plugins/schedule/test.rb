#!/usr/bin/env ruby
require 'rubygems'
require 'date'
require 'mysql'

# Date.today + ((day - Date.today.wday) % 7)
def getDate(day,numweeks)
	dow = 0
	days = 7 * numweeks

	case day 
	when "Sunday"
		dow = 0
	when "Monday"
		dow = 1
	when "Tuesday"
		dow = 2
	when "Wednesday" 
  		dow = 3
	when "Thursday" 
  		dow = 4
	when "Friday"
  		dow = 5
	when "Saturday"
		dow = 6
	else
		# No need to use this but keeping it here for an example
	end
        
       	return Date.today + (((dow - Date.today.wday)) * 100)
end

def get_db_data(sql)
	dbh = Mysql.real_connect("localhost", "root", "hccc12pass", "responses")
        query = sql
        res = dbh.query(query)
	return res
end

def listResponses(voice_command)
        squery_responses = "SELECT * FROM responses"
        res_responses = get_db_data(squery_responses)

	res_responses.each do |row_responses|
		id = row_responses[0]
		response_type_id = row_responses[1]
		response = row_responses[2]
		updated_by = row_responses[3]
		updated_date = row_responses[4]
		
		squery_lookups = "SELECT * FROM lookups	WHERE response_id = #{id}"
		res_lookups = get_db_data(squery_lookups)
		res_lookups.each do |row_lookups|
			lookup = row_lookups[1]
			if voice_command.match(/#{lookup}/i)
				return "Response: #{response}"
			end
		end
		res_lookups.free
	end
	res_responses.free
end
puts listResponses("Test Lookup")
