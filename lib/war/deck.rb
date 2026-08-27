require_relative "card"

module War
  class Deck
    SUITS = ["Hearts", "Diamonds", "Clubs", "Spades"].freeze
    RANKS = (2..14).freeze

    def initialize(cards = Deck.standard_52.shuffle)
      @cards = cards
    end

    def self.standard_52
      SUITS.flat_map { |suit| RANKS.map { |rank| Card.new(rank, suit) } }
    end

    def deal(num_players)
      unless [2, 4].include?(num_players)
        raise ArgumentError, "War only supports 2 or 4 players (got #{num_players})"
      end

      hands = Array.new(num_players) { [] }
      @cards.each_with_index { |card, i| hands[i % num_players] << card }
      hands
    end
  end
end
