require "spec_helper"

RSpec.describe War::Player do
  let(:cards) { (1..5).map { |i| War::Card.new(i + 1, "Hearts") } }
  let(:player) { War::Player.new("Alice", cards) }

  describe "#active?" do
    it "is true while the player holds cards" do
      expect(player).to be_active
    end

    it "is false once the player has no cards left" do
      empty_player = War::Player.new("Bob", [])
      expect(empty_player).not_to be_active
    end
  end

  describe "#remove_top_cards" do
    it "removes and returns the requested number of cards from the top" do
      taken = player.remove_top_cards(2)
      expect(taken.map(&:rank)).to eq([2, 3])
      expect(player.cards.map(&:rank)).to eq([4, 5, 6])
    end

    it "returns fewer cards than requested if the deck runs short" do
      taken = player.remove_top_cards(10)
      expect(taken.size).to eq(5)
      expect(player).not_to be_active
    end
  end

  describe "#add_cards" do
    it "appends cards to the bottom of the deck" do
      new_cards = [War::Card.new(14, "Spades"), War::Card.new(13, "Spades")]
      player.add_cards(new_cards)

      expect(player.cards.last(2)).to eq(new_cards)
      expect(player.cards.size).to eq(7)
    end
  end
end
