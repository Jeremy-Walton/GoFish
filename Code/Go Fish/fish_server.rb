require 'socket'
require 'json'
require_relative './fish_hand.rb'
require_relative './fish_game.rb'

class FishServer
	attr_reader :client_list, :players, :number_of_players, :names, :asker

	def initialize(port)
		@server = TCPServer.open(port)
		@client_list = []
		@players = []
		@game = nil
		@number_of_players = 2
		@names = []
		@asker = nil
		puts 'Server created on port: ' + port.to_s
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

	def ask_for_cards(card_rank, asker, giver)
		@game.ask_player_for_card(card_rank, asker, giver)
	end

	def play_round_step_1
		@asker = @game.whos_turn?
		broadcast("It is #{@asker.name}'s turn")
	end

	def play_round_step_2
		index = @players.index(@asker)
		@client_list[index].puts "What would you like to do?"
	end

	def check_input_is_valid(input)
		if(input.match(/.*([2-9]|10).*(Jack|Ace|Queen|King|[2-9]|10)/))
			parsed_input = input.match(/.*([2-9]|10).*(Jack|Ace|Queen|King|[2-9]|10)/)
			parsed_input = parsed_input.to_a
			parsed_input.shift
			return parsed_input
		else
			return ''
		end
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

if(__FILE__ == $0)

	@server = FishServer.new(3333)
	@server.accept_connections
	@server.get_names
	@server.assign_players
	@server.setup_game
	
	while(true)
		@server.display_cards
		#sleep(2)
		@server.play_round_step_1
		#sleep(2)
		@server.play_round_step_2
		#sleep(2)

			puts 'in here'
			index = @server.players.index(@server.asker)
			input = @server.get_input(index)
			puts input
			parsed_input = @server.check_input_is_valid(input)
			
		puts 'making results'
		results = @server.ask_for_cards(parsed_input[1], @server.asker, @server.players[(parsed_input[0].to_i-1)])
		@server.broadcast(results)
		# sleep(2)
	end
end