require_relative '../go fish/deck.rb'
require_relative '../go fish/playing_card.rb'
require_relative '../go fish/fish_player.rb'

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
		deck.top_card.should eq(PlayingCard.new('A').value)
	end

	it "can be shuffled" do
		deck = Deck.new
		deck2 = Deck.new
		deck2.shuffle
		deck.should_not eq(deck2)
	end

end

describe FishPlayer do
	
	it "exists" do
		player1 = FishPlayer.new([], 'Jeremy')
		player1.class.should_not eq(nil)
	end

end