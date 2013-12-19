class PlayingCard
	RANKS = %W(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
	RANKNAMES = %W(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
	attr_reader :rank

	def initialize(rank=[])
		@rank = rank
	end

	def to_s
		"#{RANKNAMES[value]}"
	end

end