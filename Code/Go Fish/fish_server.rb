require 'socket'
require 'json'

class FishServer
	attr_reader :client_list, :players, :number_of_players, :names

	def initialize(port)
		@server = TCPServer.open(port)
		@client_list = []
		@players = []
		@port = port
		@number_of_players = 4
		@names = []
		puts 'Server created on port: ' + @port.to_s
	end

	def close
		@server.close
	end

	def accept_connections	
		@number_of_players.times do |time|
			@client_list.push(@server.accept)
			puts'Player ' + (time+1).to_s + ' Connected'
		end
		broadcast("#{@number_of_players} people are connected")
	end

	def get_names
		@client_list.each do |client|
			@names.push(client.gets.chomp)
		end
	end

	def assign_players
			@client_list.each_with_index do |client, index|
				hand = FishHand.new([], @names[index])
				@players.push(hand)
			end
	end

	def broadcast(message)
		@client_list.each do |client|
			client.puts message
		end
	end

	def get_hand(client)
		JSON.parse(client.gets.chomp)
	end

	def setup_game
		@game = FishGame.new(@players)
		@game.setup
	end

	def display_cards
		@client_list.each_with_index do |client, index|
				message =  "Your cards "
			@players[index].cards.each do |card|
				message += "#{card.rank}, "
			end
			client.puts message
		end
	end

	def play_round
		asker = @game.whos_turn?
		broadcast("It is #{asker.name}'s turn")
		index = @players.index(asker)
		@client_list[index].puts "What would you like to do?"
	end

	def get_input(index)
		@client_list[index].gets.chomp
	end

	def is_running?
		if(@server)
			true
		else
			false
		end
	end

end