require "spec_helper"

RSpec.describe War::Deck do
  describe ".standard_52" do
    it "builds all 52 unique cards, 13 per suit" do
      cards = War::Deck.standard_52
      expect(cards.size).to eq(52)
      expect(cards.uniq { |c| [c.rank, c.suit] }.size).to eq(52)

      War::Deck::SUITS.each do |suit|
        expect(cards.count { |c| c.suit == suit }).to eq(13)
      end
    end
  end

  describe "#deal" do
    it "splits the deck evenly between 2 players with no overlap" do
      hands = War::Deck.new.deal(2)

      expect(hands.size).to eq(2)
      expect(hands.map(&:size)).to eq([26, 26])
      expect((hands[0] + hands[1]).uniq { |c| [c.rank, c.suit] }.size).to eq(52)
    end

    it "splits the deck evenly between 4 players" do
      hands = War::Deck.new.deal(4)

      expect(hands.size).to eq(4)
      expect(hands.map(&:size)).to eq([13, 13, 13, 13])
    end

    it "raises for anything other than 2 or 4 players" do
      expect { War::Deck.new.deal(5) }.to raise_error(ArgumentError)
      expect { War::Deck.new.deal(3) }.to raise_error(ArgumentError)
    end
  end
end
