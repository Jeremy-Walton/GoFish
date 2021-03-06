require 'socket'

class FishClient
	attr_reader :socket
	def initialize(port, name='')
		puts 'What server would you like to connect to?'
		#must change when testing
		hostname = STDIN.gets.chomp
		puts 'What is your name?'
		@name = STDIN.gets.chomp
		#@name = name
		#hostname = 'localhost' 
		@socket = TCPSocket.open(hostname,port)
		puts 'You connected'
		post_login_message
		pid = fork{ exec 'afplay', 'welcome.mp3' } 
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
		puts "Hi #{@name}, Welcome to 'Go Fish!'"
		puts "-----------------------------------------------------------"
		puts "|When it's your turn, you can ask other players for cards.|"
		puts "|A normal command consists of a number 2-10 followed      |"
		puts "|by a card rank 2-10, Jack, Queen, King or Ace            |"
		puts "|Here are some examples:                                  |"
		puts "|Give me player 2 Ace                                     |"
		puts "|3 6                                                      |"
		puts "-----------------------------------------------------------"
		puts ''
	end
end


if(__FILE__ == $0)
	@client = FishClient.new(3333)
	@client.provide_name
	Thread.new(@client.socket) do |client|
		loop do
			message =  client.gets.chomp
			puts message
			pid = fork{ exec 'afplay', 'card.wav' } if(message == "What would you like to do?")
			if(message == "Someone ran out of cards. Counting matched cards")
				pid = fork{ exec 'afplay', 'win_song.wav' }
				sleep(10)
				pid = fork{ exec 'afplay', 'congrats.wav' }
				sleep(5)
				exit
			end
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