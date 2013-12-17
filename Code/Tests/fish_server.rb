require 'socket'

class FishServer

	def initialize(port)
		@server = TCPServer.open(port)
		@client_list = []
		@port = port
		@number_of_players = 4
		@names = []
		puts 'Server created on port: ' + @port.to_s
	end

	def accept_connections	
		@number_of_players.times do |time|
			@client_list.push(@server.accept)
			puts'Player ' + (time+1).to_s + ' Connected'
		end
		broadcast("#{@number_of_players} people are connected")
	end

	def broadcast(message)
		@client_list.each do |client|
			client.puts message
		end
	end

	def is_running?
		if(@server)
			true
		else
			false
		end
	end

end