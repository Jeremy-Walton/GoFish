class MockClient

	def initialize(port, name='')
		puts 'What server would you like to connect to?'
		@hostname = 'localhost' 
		#@hostname = STDIN.gets.chomp
		@port = port
		@name = name
		@s = TCPSocket.open(@hostname,@port)
		puts 'You connected'
		puts 'Waiting for other player.'
	end

end