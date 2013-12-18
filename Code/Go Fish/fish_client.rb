require 'socket'

class FishClient
	attr_reader :socket
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
			message = @socket.recv_nonblock(100)
			puts message+' in display_broadcast' if(message != '')
			if(message == "What would you like to do?")
				puts message+" tag"
				@client.provide_input
			end
		rescue
			
		end
	end

	def display_narrowcast
		
	end

	def provide_input
		input = STDIN.gets.chomp
		#puts input
		@socket.puts input 
	end

	def give_hand
		@socket.puts @hand.to_json
	end

end


if(__FILE__ == $0)
	@client = FishClient.new(3333)
	@client.provide_name
	Thread.new(@client.socket) do |client|
		loop do
			puts client.gets.chomp
		end
	end
	begin
		loop do
			line = readline
			@client.socket.puts line unless line.strip.empty?
		end
	rescue EOFError
		puts 'Leaving...'
	end
	# @client.get_broadcast
	# @client.provide_name

	# while(true)
	# 	@client.display_broadcast
	# 	# 	puts 'What would you like to do?'
	# 	# 	@client.provide_input
	# 	# end
	# end	
end