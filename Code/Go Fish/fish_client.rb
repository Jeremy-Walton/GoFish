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
		post_login_message
		puts 'Waiting for other player.'
	end

	def provide_name
		@socket.puts @name
	end

	def get_broadcast
		@socket.gets.chomp
	end

	def post_login_message
		puts ''
		puts "Hi #{@name}, Welcome to Go Fish!"
		puts "When it's your turn, you can ask other players for cards."
		puts "A normal command consists of a number 2-10 followed "
		puts "by a card rank 2-10, Jack, Queen, King or Ace"
		puts "Here are some examples:"
		puts "Give me player 2 Ace"
		puts "3 6"
		puts ''
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
end