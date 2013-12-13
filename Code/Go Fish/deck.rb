require_relative './playing_card'

class Deck

	def initialize
		@cards = []
		ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
		4.times do
			ranks.each do |rank|
				@cards = @cards.push(PlayingCard.new(rank))
			end
		end
	end

	def size
		@cards.count
	end

	def top_card
		@cards.last.value
	end

	def shuffle
		@cards.shuffle!
	end

	def deal
		@cards.pop
	end

end