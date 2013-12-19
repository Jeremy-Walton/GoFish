class FishHand
	attr_reader :books, :cards, :name
	def initialize(cards=[], name='')
		@cards = cards
		@books = []
		@name = name
	end

	def number_of_books
		@books.count
	end

	def play_top_card
		@cards.pop
	end

	def number_of_cards
		@cards.count
	end

	def take_cards(cards)
		@cards.push(*cards)
	end

	def got_any?(card_rank)
		return_cards = []
		@cards.each{|card| return_cards.push(card) if card.rank == card_rank}
		@cards.delete_if{|card| card.rank == card_rank}
		return_cards
	end

	def check_for_books(card_rank)
		return_cards, book = [], []
			@cards.each{|card| book.push(card) if card_rank == card.rank}
			return_cards = book if(book.count == 4)
			unless(return_cards.first == nil)
				@cards.delete_if{|card| card.rank == return_cards.first.rank}
				@books.push(return_cards.first.rank)
			end
		@books
	end

end