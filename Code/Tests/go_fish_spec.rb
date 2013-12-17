require_relative '../go fish/deck.rb'
require_relative '../go fish/playing_card.rb'
require_relative '../go fish/fish_hand.rb'
require_relative '../go fish/fish_game.rb'
require_relative '../go fish/fish_server.rb'
require_relative '../go fish/fish_client.rb'
require_relative '../go fish/mock_client.rb'


describe Deck do

	it "exists" do
		deck = Deck.new
		deck.class.should_not eq(nil)
	end
	
	it "has 52 cards" do
		deck = Deck.new
		deck.size.should eq(52)
	end

	it "cards are playing cards" do
		deck = Deck.new
		card = PlayingCard.new
		deck.take_top_card.class.should eq(card.class)
	end

	it "is shuffled" do
		deck = Deck.new
		deck2 = Deck.new
		deck.should_not eq(deck2)
	end

end

describe FishHand do
	
	it "exists" do
		player1 = FishHand.new([])
		player1.class.should_not eq(nil)
	end

	it "check for books" do
		player1 = FishHand.new([PlayingCard.new('2'), PlayingCard.new('2'), PlayingCard.new('2'), PlayingCard.new('2'), PlayingCard.new('3'), PlayingCard.new('3'), PlayingCard.new('3'), PlayingCard.new('3')])
		player2 = FishHand.new([PlayingCard.new('4'), PlayingCard.new('3'), PlayingCard.new('7'), PlayingCard.new('A'), PlayingCard.new('K')])
		player1.check_for_books
		player2.check_for_books
		player1.books.should eq(['2', '3'])
		player2.books.should eq([])
	end

end

describe FishGame do

	it "exists" do
		game = FishGame.new
		game.class.should_not eq(nil)
	end

	it "deals cards" do
		player1 = FishHand.new
		game = FishGame.new([player1])
		game.setup
		player1.number_of_cards.should eq(5)
	end

	it "checks cards" do 
		player1 = FishHand.new
		player2 = FishHand.new
		game = FishGame.new([player1, player2])
		game.setup
		returned_cards = player2.got_any?('4')
		if(returned_cards == [])
			returned_cards.first.should eq(nil)
		else
			returned_cards.first.rank.should eq('4')
		end
	end

	it "sets up game correctly" do
		player1 = FishHand.new
		player2 = FishHand.new
		player3 = FishHand.new
		player4 = FishHand.new
		player5 = FishHand.new
		game = FishGame.new([player1, player2, player3, player4, player5])
		game.players.last.should eq(player5)
	end

	it "takes typical turn" do
		player1 = FishHand.new([PlayingCard.new('6'), PlayingCard.new('8'), PlayingCard.new('5'), PlayingCard.new('4'), PlayingCard.new('2')], "Jeremy")
		player2 = FishHand.new([PlayingCard.new('8'), PlayingCard.new('2'), PlayingCard.new('2'), PlayingCard.new('2'), PlayingCard.new('3')], "Jack")
		game = FishGame.new([player1, player2])
		#game.print_cards
		results = game.ask_player_for_card('2', player1, player2)
		#puts results
		player1.check_for_books
		player1.books.should eq(['2'])

	end

	it "play game" do
		player1 = FishHand.new([], "Jeremy")
		player2 = FishHand.new([], "Jack")
		game = FishGame.new([player1, player2])
		game.setup
		#game.print_cards
		asker = game.whos_turn?
		#puts "It is #{asker.name}'s turn"
		#puts 'who ya gonna take from'
		giver = player2
		results = game.ask_player_for_card('2', asker, giver)
		#puts results
	end

end


describe FishServer do

	before do
		@server = FishServer.new(3333)
	end

	after do 
		@server.close
	end

	it "starts" do
		@server.is_running?.should eq(true)
	end

	it "can accept connections" do
		player1 = FishClient.new(3333)
		player2 = FishClient.new(3333)
		player3 = FishClient.new(3333)
		player4 = FishClient.new(3333)
		@server.accept_connections
		@server.client_list.count.should eq(4)
	end

	it "receives broadcasts" do
		player1 = FishClient.new(4444, 'jill')
		player2 = FishClient.new(4444, 'bob')
		player3 = FishClient.new(4444, 'joe')
		player4 = FishClient.new(4444, 'bill')

		@server.accept_connections
		player1.get_broadcast.should eq("#{server.number_of_players} people are connected")
		player2.get_broadcast
		player3.get_broadcast
		player4.get_broadcast.should eq("#{server.number_of_players} people are connected")
	end

	it "can get name back from clients" do
		server = FishServer.new(5555)
		player1 = FishClient.new(5555, 'jill')
		player2 = FishClient.new(5555, 'bob')
		player3 = FishClient.new(5555, 'joe')
		player4 = FishClient.new(5555, 'bill')

		server.accept_connections
		player1.get_broadcast
		player2.get_broadcast
		player3.get_broadcast
		player4.get_broadcast

		player1.provide_name
		player2.provide_name
		player3.provide_name
		player4.provide_name
		server.get_names
		server.names.should eq(['jill', 'bob', 'joe', 'bill'])
	end

	it "can make a game with four clients" do
		server = FishServer.new(6666)
		player1 = FishClient.new(6666, 'jill')
		player2 = FishClient.new(6666, 'bob')
		player3 = FishClient.new(6666, 'joe')
		player4 = FishClient.new(6666, 'bill')

		server.accept_connections
		player1.get_broadcast
		player2.get_broadcast
		player3.get_broadcast
		player4.get_broadcast

		player1.provide_name
		player2.provide_name
		player3.provide_name
		player4.provide_name
		server.get_names

		server.assign_players

		server.setup_game
		server.players.first.number_of_cards.should eq(5)
		server.players.last.number_of_cards.should eq(5)
	end

	it "can play a round" do
		server = FishServer.new(4444)
		#players = %w(bob jill bill bo).map {|name| FishClient.new(4444, name)}
		players = %w(bob jill bill bo).map {|name| MockClient.new(4444, name)}
		server.accept_connections
		players.each {|player| player.get_broadcast}

		players.each {|player| player.provide_name}
		server.get_names

		server.assign_players

		server.setup_game

		server.play_round
		expect(client1.output).to include "something"
	end

end

# def capture_output(socket)
# 	socket.read_nonblock(1000)
# rescue
# 	""
# end

# context "Game already connects to clients" do

# end