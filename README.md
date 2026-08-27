# War Card Game

Command-line implementation of War, in Ruby.

## Setup

Requires Ruby 3.2+.

```bash
bundle install
```

## Run the game

```bash
ruby bin/war      # 2 players (default)
ruby bin/war 4    # 4 players
```

Prints each round as it happens, including any wars, and announces the winner.

## Run tests

```bash
bundle exec rspec
```

## Notes

- Only 2 or 4 players are supported, per the rules.
- When a player wins a round, the cards go to the bottom of their deck in the order they were played (the rules say "any order" is fine).
- Games are capped at 100,000 rounds as a safety net against a theoretical infinite loop. In practice this should never be hit.
