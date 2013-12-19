require_relative './playing_card'

class Deck

	def initialize
		@cards = []
		ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
		4.times do
			ranks.each do |rank|
				@cards = @cards.push(PlayingCard.new(rank))
			end
		end
		shuffle
	end

	def size
		@cards.count
	end

	def shuffle
		@cards.shuffle!
	end

	def take_top_card
		@cards.pop
	end

end