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
  end

  def play
    @grid.display_grid

    until (winner_symbol = check_game_state)
      currentPlayer = (turn % 2).zero? ? @player1 : @player2
      puts "#{currentPlayer.name} turn:"

      begin
        playerMove = gets.chomp.capitalize
        @grid.add_symbol(playerMove, symbol)
        display_board
      rescue StandardError => e
        puts e
        puts 'Pick again'
      end
    end

    announce_winner(winner_symbol)
  end

  def turn
    @grid.occupied_cell_count
  end

  def check_game_state
    return @grid.winner if @grid.winner

    reset_game if @grid.is_full?
  end

  def announce_winner(winner)
    player_winner = @players.find { |player| player.symbol == winner }
    puts 'We have a winner!'
    puts "Congratulations #{player_winner.name}"
  end

  def display_board
    puts `clear`
    @grid.display_grid
  end

  def reset_game
    stalemate
    clear_board
  end

  def stalemate
    display_board
    puts 'We reached a stalemate lets reset the table'
    sleep 3
  end

  def clear_board
    @grid = Grid.new
    @grid.display_grid
  end
end

# game = Game.new
# game.play
