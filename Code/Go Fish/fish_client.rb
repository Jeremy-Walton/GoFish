require 'socket'

class FishClient

	def initialize(port, name='')
		puts 'What is your name?'
		hostname = 'localhost' 
		#must change when testing
		@name = STDIN.gets.chomp
		#@name = name
		@socket = TCPSocket.open(hostname,port)
		puts 'You connected'
		puts 'Waiting for other player.'
	end

	def provide_name
		@socket.puts @name
	end

	def get_broadcast
		puts @socket.gets.chomp
	end

	def display_broadcast
		begin
			 @socket.read_nonblock(100)
		rescue

		end
	end

	def display_narrowcast
		begin
			puts @socket.read_nonblock(100)
		rescue
			
		end
	end

	def provide_input
		input = gets.chomp
		@socket.puts input
	end

	def give_hand
		@socket.puts @hand.to_json
	end

end


if(__FILE__ == $0)
	@client = FishClient.new(3333)
	@client.get_broadcast
	@client.provide_name

	@client.get_broadcast
	@client.get_broadcast
	puts 'before loop'
	while(true)
		if(@client.display_narrowcast)
			puts 'maybe here'
			@client.provide_input
		end
		@client.get_broadcast
	end	
end