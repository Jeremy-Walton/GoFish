require 'socket'
require_relative './fish_hand.rb'
require_relative './fish_game.rb'

class FishServer
	attr_reader :player_sockets, :players, :number_of_players, :names, :asker, :game

	def initialize(port)
		@server = TCPServer.open(port)
		@player_sockets, @players, @names = [], [], []
		@game, @asker = nil, nil
		puts "How many players can connect?"
		@number_of_players = STDIN.gets.chomp.to_i
		#@number_of_players = 4
		puts 'Server created on port: ' + port.to_s
	end

	def close
		@server.close
	end

	def accept_connections	
		@number_of_players.times do |time|
			@player_sockets.push(@server.accept)
			puts'Player '+(time+1).to_s+' Connected'
		end
		broadcast("#{@number_of_players} people are connected")
	end

	def get_names
		@player_sockets.each do |client|
			@names.push(client.gets.chomp)
		end
	end

	def assign_players
			@player_sockets.each_with_index do |client, index|
				hand = FishHand.new([], @names[index])
				@players.push(hand)
			end
	end

	def broadcast(message)
		@player_sockets.each do |client|
			client.puts message
		end
	end

	def setup_game
		@game = FishGame.new(@players)
		@game.setup
	end

	def display_cards
		@player_sockets.each_with_index do |client, index|
			card_ranks = []
			@players[index].cards.each {|card| card_ranks.push(card.rank)}
			card_ranks.sort!
			top_line, middle_line, bottom_line = '', '', ''
			card_ranks.each do |card|
				if(card == '10')
					top_line += " ---- "
					bottom_line += " ---- "
				else
					top_line += " --- "
					bottom_line += " --- "
				end
				middle_line += " |#{card}| "
			end
			client.puts top_line
			client.puts middle_line
			client.puts bottom_line
		end
	end

	def ask_for_cards(card_rank, asker, giver)
		@game.ask_player_for_card(card_rank, asker, giver)
	end

	def determine_whos_turn
		@asker = @game.whos_turn?
		broadcast("It is #{@asker.name}'s turn")
	end

	def play_round_step_2
		index = @players.index(@asker)
		@player_sockets[index].puts "What would you like to do?"
	end

	def check_input_is_valid(input)
		if(input.match(/.*([1-9]|10).*(J|A|Q|K|[2-9]|10)/))
			parsed_input = input.match(/.*([1-9]|10).*(J|A|Q|K|[2-9]|10)/)
			parsed_input = parsed_input.to_a
			parsed_input.shift
			return parsed_input
		else
			return ''
		end
	end

	def count_player_books
		winner = '|'
		book_count, new_book_count = 0, 0
		ties_list = []
		@players.each do |player|
			new_book_count = player.number_of_books
			if(new_book_count > book_count)
				book_count = new_book_count
				winner = player.name+' |'
				ties_list = []
			else
				ties_list.push(player.name) if (new_book_count == book_count)
			end		
		end
		if(ties_list.size > 0)
			ties_list.each do |player|
				winner += " #{player} |"
			end
			winner = "And the Winners are.. " + winner + ". You guys rock!"
		else
			winner = "And the Winner is.. "+winner+". You rock!"
		end
		winner
	end

	def get_input(index)
		@player_sockets[index].gets.chomp
	end

	def display_player_names
		message = '|'
		@players.each_with_index do |player, index|
			message += " Player #{(index+1).to_s} is #{player.name} | "
		end
		broadcast(message)
	end

	def is_running?
		if(@server)
			true
		else
			false
		end
	end

	def game_over
		@players.any? { |player| player.cards.count == 0}
	end

end

if(__FILE__ == $0)

	@server = FishServer.new(3333)
	@server.accept_connections
	@server.get_names
	@server.assign_players
	@server.setup_game
	sleep(2)
	pid = fork{ exec 'afplay', 'shuffle.mp3' }
	while(!@server.game_over)
		@server.broadcast('')
		@server.broadcast("----------------------------------------------------------------------------------------------------")
		@server.display_player_names
		@server.display_cards
		@server.broadcast("----------------------------------------------------------------------------------------------------")
		@server.determine_whos_turn
		@server.play_round_step_2

		puts 'getting input'
		index = @server.players.index(@server.asker)
		while(true)
			input = @server.get_input(index)
			parsed_input = @server.check_input_is_valid(input)
			if(parsed_input != '' && parsed_input[0].to_i <= @server.number_of_players && parsed_input[0].to_i > 0)
				cards = []
				@server.asker.cards.each do |card|
					cards.push(card.rank)
				end
				if(cards.include?(parsed_input[1]) == false)
					@server.player_sockets[index].puts "You cannot ask for a card you don't already have."
				else
					break
				end
			end
			@server.player_sockets[index].puts "Please type something valid."
		end
		puts 'making results'
		results = @server.ask_for_cards(parsed_input[1], @server.asker, @server.players[(parsed_input[0].to_i-1)])
		@server.broadcast(results)
		@server.broadcast('')
	end
	@server.broadcast("Someone ran out of cards. Counting matched cards")
	winner = @server.count_player_books
	@server.broadcast("#{winner}")
end