require 'tweakSiri'
require 'siriObjectGenerator'
require 'json' 
require 'open-uri'
require 'httparty'
require 'rubygems'
require 'mysql'

#############
# This example plugin is updates a database for a simple work schedule application. 
#############

class SiriSchedule < SiriPlugin
	def getDate(dow,numweeks)
		if dow  == 3
			return Date.today + ((day - Date.today.wday) % 7)
		end 
	end	
	def updateSchedule(day, startTime, endTime, connection)
		self.plugin_manager.block_rest_of_session_from_server
		dbh = Mysql.real_connect("localhost", "root", "hccc12pass", "schedules")
		entryDate = Date.today.to_s
		dconv = Date.strptime(entryDate, "%Y-%m-%d")
                dow = dconv.strftime('%A')
		if(day.match(/Next/i))
			puts dow
		else
			puts dow
		end
		squery = "UPDATE schedules SET startTime  = '" + startTime + "', endTime = '" + endTime + "', entryDate = '" + entryDate + "' WHERE day = '" + day + "'"
		#puts squery
		res = dbh.query(squery)
		connection.inject_object_to_output_stream(generate_siri_utterance(connection.lastRefId, "Your schedule has been updated for #{day}. Your hours are #{startTime} to #{endTime}"))
	end
	
	def readSchedule(day, connection)
		self.plugin_manager.block_rest_of_session_from_server
		 dbh = Mysql.real_connect("localhost", "root", "hccc12pass", "schedules")
		 squery = "SELECT * FROM schedules WHERE day = '" + day + "'"
		 nquery = "SELECT * FROM schedules WHERE day = 'Next " + day + "'"
		 #puts squery
                 res = dbh.query(squery)
		 resn = dbh.query(nquery)
		 startTime = ""
		 endTime = ""
		 entryDate = ""
                 res.each do |row|
                       startTime = row[2]
                       endTime = row[3]
		       entryDate = row[4]
                 end
                 res.free
		 
		 startTimen = ""
		 endTimen = ""
		 entryDaten = ""
		 resn.each do |row|
			startTimen = row[2]
			endTimen = row[3]
			entryDaten = row[4]
		 end
		 resn.free
		 
		 testDate = Date.strptime(entryDate, "%Y-%m-%d")
		 puts testDate.strftime('%A')
		 puts get_date.to_s
		 if ((entryDaten > entryDate) && (entryDaten < Date.today.to_s))
			uquery = "UPDATE schedules SET startTime = '" + startTimen + "', endTime = '" + endTimen + "' WHERE day = '" + day + "'"
			#resu = dbh.query(squery)
		 end
		 
		 if(startTime == "0 AM" && endTime == "0 PM")
			response = "You have #{day} off.  Party Time!"	
		 else
			response = "You are working from #{startTime} until #{endTime} on #{day}"
		 end
                 connection.inject_object_to_output_stream(generate_siri_utterance(connection.lastRefId, response))
	end
	
	def speech_recognized(object, connection, phrase)	
		if(phrase.match(/schedule/i))
			daysToUpdate = phrase.scan(/monday|tuesday|wednesday|thursday|friday|saturday|sunday/i)
			i=0
			daysToUpdate.each { |day|
				if(day)
					if(phrase.match(/next #{day}/i))
						day = "Next #{day}"
					end
                                       	if(phrase.match(/update/i))
						if(phrase.match(/#{day} off/i))
							startTime = 0
							startAMPM = "AM"
							endTime = 0
							endAMPM = "PM"
						else
                                               		startTime = phrase.scan(/\d+/)[i]
                                               		startAMPM = phrase.scan(/AM|PM/)[i]
                                               		endTime = phrase.scan(/\d+/)[i+1]
                                               		endAMPM = phrase.scan(/AM|PM/)[i+1]
							i=i+2
						end
                                               	connection.inject_object_to_output_stream(object)
                                               	updateSchedule(day, "#{startTime} #{startAMPM}", "#{endTime} #{endAMPM}", connection)
                                       	elsif(phrase.match(/work/i))
                                               	connection.inject_object_to_output_stream(object)
                                               	readSchedule(day, connection)
                                       	end
                               	end
			}	
		end
		object
	end

	###################################
	#plusgin implementations:
        def object_from_guzzoni(object, connection)
                object
        end

        #Don't forget to return the object!
        def object_from_client(object, connection)
                object
        end

        def unknown_command(object, connection, command)
                if(command.match(/blahblahblah/i))
                        self.plugin_manager.block_rest_of_session_from_server
                        return generate_siri_utterance(connection.lastRefId, "blah blah blah")
                end
                object
        end
end
