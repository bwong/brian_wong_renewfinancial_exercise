module War
  class Card
    include Comparable

    RANK_NAMES = {
      11 => "Jack",
      12 => "Queen",
      13 => "King",
      14 => "Ace"
    }.freeze

    attr_reader :rank, :suit

    def initialize(rank, suit)
      @rank = rank
      @suit = suit
    end

    def name
      RANK_NAMES[rank] || rank.to_s
    end

    def <=>(other)
      rank <=> other.rank
    end

    def to_s
      "#{name} of #{suit}"
    end
  end
end
