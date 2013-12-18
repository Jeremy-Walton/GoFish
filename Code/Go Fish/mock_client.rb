class MockClient

	def initialize(port, name='')
		puts 'What server would you like to connect to?'
		@hostname = 'localhost' 
		#@hostname = STDIN.gets.chomp
		@port = port
		@name = name
		@broadcast
		@socket = TCPSocket.open(@hostname,@port)
		puts 'You connected'
		puts 'Waiting for other player.'
	end

	def get_broadcast
		@broadcast = @socket.gets.chomp
		@broadcast
	end

	def provide_name
		@socket.puts @name
	end

	def display_broadcast
		puts get_broadcast
	end

	def output
		@broadcast
	end

end