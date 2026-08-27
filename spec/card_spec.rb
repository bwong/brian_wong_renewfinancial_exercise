require "spec_helper"

RSpec.describe War::Card do
  describe "#name" do
    it "shows numeric ranks as themselves" do
      expect(War::Card.new(7, "Hearts").name).to eq("7")
    end

    it "shows face ranks by name, with Ace as the highest" do
      expect(War::Card.new(11, "Spades").name).to eq("Jack")
      expect(War::Card.new(12, "Spades").name).to eq("Queen")
      expect(War::Card.new(13, "Spades").name).to eq("King")
      expect(War::Card.new(14, "Spades").name).to eq("Ace")
    end
  end

  describe "comparison" do
    it "ranks an Ace above a King, and any numeric card by its rank" do
      expect(War::Card.new(14, "Clubs")).to be > War::Card.new(13, "Clubs")
      expect(War::Card.new(10, "Clubs")).to be > War::Card.new(9, "Hearts")
    end

    it "ignores suit entirely" do
      expect(War::Card.new(9, "Hearts")).to eq(War::Card.new(9, "Spades"))
    end
  end
end
