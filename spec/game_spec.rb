require "spec_helper"

RSpec.describe War::Game do
  def cards_for(*ranks, suit: "T")
    ranks.map { |r| War::Card.new(r, suit) }
  end

  def player(name, ranks)
    War::Player.new(name, cards_for(*ranks))
  end

  def play_round(game, current_players)
    game.send(:play_round, current_players)
  end

  describe "a round with no tie" do
    it "awards all cards in play to the higher card, in rank order" do
      a = player("A", [13])
      b = player("B", [5])
      game = described_class.new([a, b], logger: nil)

      play_round(game, [a, b])

      expect(a.cards.map(&:rank)).to eq([13, 5])
      expect(b).not_to be_active
    end
  end

  describe "a tied round (war)" do
    it "recurses into a single war and awards the whole pool to the winner" do
      a = player("A", [10, 2, 3, 4, 9])
      b = player("B", [10, 5, 6, 7, 8])
      game = described_class.new([a, b], logger: nil)

      play_round(game, [a, b])

      expect(a.size).to eq(10)
      expect(b).not_to be_active
      expect(a.cards.map(&:rank).sort).to eq([2, 3, 4, 5, 6, 7, 8, 9, 10, 10])
    end

    it "lets a player who runs out mid-war contest with their last card face up" do
      # A has only 3 cards total: the tied card, plus 2 left for the war
      # (fewer than the 3-down-plus-1-up a war normally needs). Their last
      # card (9) must still stand as their face-up war card.
      a = player("A", [10, 5, 9])
      b = player("B", [10, 1, 2, 3, 4])
      game = described_class.new([a, b], logger: nil)

      play_round(game, [a, b])

      expect(a.size).to eq(8) # all of A's and B's cards
      expect(b).not_to be_active
    end
  end

  describe "#play" do
    it "eliminates players who run out of cards and continues with the rest" do
      p1 = player("P1", [14, 13])
      p2 = player("P2", [12, 11])
      p3 = player("P3", [10, 9])
      p4 = player("P4", [8, 7])
      game = described_class.new([p1, p2, p3, p4], logger: nil)

      winner = game.play

      expect(winner).to eq(p1)
      expect(p1.size).to eq(8)
      [p2, p3, p4].each { |p| expect(p).not_to be_active }
    end

    it "returns nil and stops after max_rounds if no one has won yet" do
      a = player("A", [5, 3])
      b = player("B", [2, 9])
      game = described_class.new([a, b], logger: nil, max_rounds: 1)

      winner = game.play

      expect(winner).to be_nil
      expect(a.size + b.size).to eq(4)
    end
  end
end
