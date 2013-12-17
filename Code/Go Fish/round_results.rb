class RoundResults

	def initialize(asker, giver, card_rank, number_of_cards, books)
		@asker = asker
		@giver = giver
		@card_rank = card_rank
		@number_of_cards = number_of_cards
		@books = books
	end

	def get_results
		if(@number_of_cards == 0)
			if (@books.first == nil)
				return "#{@asker.name} asked #{@giver.name} for #{@card_rank}s, but he had none, #{@asker.name} will take from deck. #{@asker.name} found no matches"
			else
				return "#{@asker.name} asked #{@giver.name} for #{@card_rank}s, but he had none, #{@asker.name} will take from deck. #{@asker.name} found these matches: #{@books}"
			end
		else
			if (@books.first == nil)
				return "#{@asker.name} asked #{@giver.name} for #{@card_rank}s, and he had #{@number_of_cards}, #{@asker.name} took them. #{@asker.name} found no matches"
			else
				return "#{@asker.name} asked #{@giver.name} for #{@card_rank}s, and he had #{@number_of_cards}, #{@asker.name} took them. #{@asker.name} found these matches: #{@books}"
			end
		end
	end

end	