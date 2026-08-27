module War
  class Player
    attr_reader :name, :cards

    def initialize(name, cards)
      @name = name
      @cards = cards
    end

    def active?
      !cards.empty?
    end

    def size
      cards.size
    end

    def remove_top_cards(n)
      cards.shift(n)
    end

    def add_cards(new_cards)
      cards.concat(new_cards)
    end
  end
end
