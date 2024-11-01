# frozen_string_literal: true

require_relative 'player'
require_relative 'grid'

# Game class will initialize the game handle all rounds and check for winning conditions
class Game
  include GamePlayerInterface
  include WinCondition

  attr_reader :players, :board

  def initialize(player1_name = get_player_name(1),
                 player2_name = get_player_name(2),
                 grid = Grid.new)
    @player1 = Player.new(player1_name, 'x')
    @player2 = Player.new(player2_name, 'o')
    @players = [@player1, @player2]
    @board = grid
    @win_condition = 3
  end

  def play
    @board.display_grid
    until (winner_symbol = check_game_state)
      current_player = current_player_turn
      puts "#{current_player.name} turn:"

      player_move(current_player)
      display_board
    end
    announce_winner(winner_symbol)
  end

  def current_player_turn
    turn.even? ? @player1 : @player2
  end

  def player_move(player)
    loop do
      picked_cell = gets.chomp.capitalize
      @board.add_symbol(picked_cell, player.symbol)
      break
    rescue InputError => e
      puts e
      puts "You can't chose that, pick again"
    end
  end

  def turn
    @board.occupied_cell_count
  end

  def check_game_state
    return winner if winner

    reset_game if @board.full?
  end

  def announce_winner(winner)
    player_winner = @players.find { |player| player.symbol == winner }
    puts 'We have a winner!'
    puts "Congratulations #{player_winner.name}"
  end

  def display_board
    puts `clear`
    @board.display_grid
  end

  def reset_game
    stalemate
    change_player_order
    clear_board
  end

  def stalemate
    display_board
    puts 'We reached a stalemate lets reset the table'
    sleep 3
  end

  def change_player_order
    @player1, @player2 = @player2, @player1
  end

  def clear_board
    @board = Grid.new
    @board.display_grid
  end
end

# game = Game.new
# game.play
