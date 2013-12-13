class FishPlayer
	def initialize(cards=[], name)
		@cards = cards
		@name = name
	end
	def play_top_card
		@cards.pop
	end
	def name
		@name
	end
	def number_of_cards
		@cards.count
	end
	def take_cards(cards)
		@cards.push(*cards)
	end
	def take_card_from_deck(card)
		@cards.unshift(card)
	end
end