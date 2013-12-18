require_relative './deck.rb'
require_relative './round_results.rb'

class FishGame
	attr_reader :players

	def initialize(players=[])
		@players = players
		@turn_order = players
		@deck = Deck.new
	end

	def setup
		deal
	end

	def whos_turn?
		@turn_order[0]
	end

	def print_cards
		@players.each do |player|
			print "Player #{@players.index(player)+1} cards: "
			player.cards.each do |card|
				print card.rank + ", "
			end
			puts ""
		end
	end

	def ask_player_for_card(card_rank, asker, giver)
		cards = giver.got_any?(card_rank)
		if(cards.count == 0)
			card = go_fish
			asker.take_cards(card)
			@turn_order = @turn_order.rotate if(card.rank != card_rank)
		else
			asker.take_cards(cards)
			@turn_order = @turn_order.rotate if(cards.first.rank != card_rank)
		end
		books = asker.check_for_books
		round_info = RoundResults.new(asker, giver, card_rank, cards.count, books)
		results = round_info.get_results
		return results
	end

	def deal
		if (@players.count == 2)
			7.times do
				@players.each do |player|
					player.take_cards(@deck.take_top_card)
				end	
			end
		else
			5.times do
				@players.each do |player|
					player.take_cards(@deck.take_top_card)
				end	
			end
		end
	end

	def go_fish
		@deck.take_top_card
	end

end