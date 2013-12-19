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

	def ask_player_for_card(card_rank, asker, giver)
		cards = giver.got_any?(card_rank)
		if(cards.count == 0)
			card = go_fish
			asker.take_cards(card)
			books = asker.check_for_books(card.rank)
			change_turn_order if(card.rank != card_rank)
		else
			asker.take_cards(cards)
			books = asker.check_for_books(cards.first.rank)
			change_turn_order if(cards.first.rank != card_rank)
		end
		round_info = RoundResults.new(asker, giver, card_rank, cards.count, books)
		round_info.get_results
	end

	def change_turn_order
		@turn_order = @turn_order.rotate
	end

	def deal
		if (@players.count == 2)
			7.times {@players.each { |player| player.take_cards(@deck.take_top_card)}}
		else
			5.times {@players.each { |player| player.take_cards(@deck.take_top_card)}}
		end

	end

	def go_fish
		@deck.take_top_card
	end

end