# frozen_string_literal: true

require_relative 'player'
require_relative 'grid'

# Game class will initialize the game handle all rounds and check for winning conditions
class Game
  include GamePlayerInterface

  attr_reader :grid, :players

  def initialize(player1 = get_player_name(1),
                 player2 = get_player_name(2),
                 grid = Grid.new)
    @player1 = Player.new(player1, 'x')
    @player2 = Player.new(player2, 'o')
    @players = [@player1, @player2]
    @grid = grid
    @turn = 0
  end

  def reset_game
    puts `clear`
    @grid.display_grid
    puts 'We reached a stale lets reset the table'
    sleep 3
    @grid = Grid.new
    @turn = 0
    @grid.display_grid
  end

  def play
    @grid.display_grid

    until winner = @grid.winner
      symbol = (@turn % 2).zero? ? @player2.symbol : @player1.symbol
      puts "#{@players.find { |player| player.symbol == symbol }.name} turn"

      begin
        @grid.add_symbol(gets.chomp.capitalize, symbol)
        puts `clear` # Clear screen after a valid move
        @grid.display_grid
      rescue StandardError => e
        puts e
        puts 'Pick again'
      else
        @turn = check_game_state
      end
    end

    announce_winner(winner)
  end

  def check_game_state
    @turn += 1
    reset_game if @turn >= @grid.rows * @grid.column
    @turn
  end

  def announce_winner(winner)
    player_winner = @players.find { |player| player.symbol == winner }
    puts 'We have a winner!'
    puts "Congratulations #{player_winner.name}"
  end
end

# game = Game.new
# game.play
