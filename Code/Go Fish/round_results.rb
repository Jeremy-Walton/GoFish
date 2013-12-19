class RoundResults

	def initialize(asker, giver, card_rank, number_of_cards, books)
		@asker = asker
		@giver = giver
		@card_rank = card_rank
		@number_of_cards = number_of_cards
		@books = books
	end

	def get_results
		message = "#{@asker.name} asked #{@giver.name} for #{@card_rank}s, "
		message2 = "but he/she had none, #{@asker.name} will take from deck. "
		message3 = "and he/she had #{@number_of_cards}, #{@asker.name} took them. "
		message4 = "#{@asker.name} found no matches"
		message5 = "#{@asker.name} found these matches: #{@books}"
		if(@number_of_cards == 0)
			if (@books.first == nil)
				return message + message2 + message4
			else
				return message + message2 + message5
			end
		else
			if (@books.first == nil)
				return message + message3 + message4
			else
				return message + message3 + message5
			end
		end
		@books = []
	end

end	