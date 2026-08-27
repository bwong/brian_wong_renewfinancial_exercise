module War
  class Game
    # if no player has won after MAX rounds, we should call it a stalemate/draw.
    DEFAULT_MAX_ROUNDS = 100_000

    attr_reader :players

    def initialize(players, logger: $stdout, max_rounds: DEFAULT_MAX_ROUNDS)
      @players = players
      @logger = logger
      @max_rounds = max_rounds
    end

    # Plays loops until someone wins or max reached.
    # Returns the winning Player, or nil on a stalemate.
    def play
      round = 0

      loop do
        active = players.select { |player| player.active? }
        break if active.size <= 1

        round += 1
        log("\n=== Round #{round} ===")
        play_round(active)

        if round >= @max_rounds
          log("\nNo winner after #{@max_rounds} rounds - calling it a stalemate.")
          return nil
        end
      end

      winner = players.find { |player| player.active? }
      log("\n#{winner.name} wins the game after #{round} rounds!")
      winner
    end

    private

    def play_round(current_players)
      pool = []
      play_cards(current_players, pool, face_down_count: 0)
    end

    # function to play cards for each current players
    def play_cards(current_players, pool, face_down_count:)
      face_ups = {}

      current_players.each do |player|
        taken = player.remove_top_cards(face_down_count + 1)
        next if taken.empty?

        face_up = taken.pop
        pool.concat(taken)
        pool << face_up
        face_ups[player] = face_up

        if face_down_count == 0
          log("  #{player.name} plays: #{face_up}")
        else
          log("  #{player.name} plays #{face_up} face up (war)")
        end
      end

      highest_rank = face_ups.values.map { |card| card.rank }.max
      winners = []
      face_ups.each do |player, card|
        winners << player if card.rank == highest_rank
      end

      if winners.size == 1
        winner = winners.first
        winner.add_cards(pool)
        log("  #{winner.name} wins #{pool.size} cards.")
      else
        log("  WAR between #{winners.map { |player| player.name }.join(', ')}!")
        play_cards(winners, pool, face_down_count: 3)
      end
    end

    def log(message)
      @logger.puts(message) if @logger
    end
  end
end
