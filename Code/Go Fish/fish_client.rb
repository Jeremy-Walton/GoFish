require 'socket'

class FishClient

	def initialize(port, name='')
		puts 'What server would you like to connect to?'
		hostname = 'localhost' 
		#@hostname = STDIN.gets.chomp
		@name = name
		@socket = TCPSocket.open(hostname,port)
		puts 'You connected'
		puts 'Waiting for other player.'
	end

	def provide_name
		@socket.puts @name
	end

	def get_broadcast
		@socket.gets.chomp
	end

	def display_broadcast
		puts get_broadcast
	end

	def give_hand
		@socket.puts @hand.to_json
	end

end