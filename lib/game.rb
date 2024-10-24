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

  def turn
    @grid.occupiedCellCount
  end

  def play
    @grid.display_grid

    until winner = @grid.winner
      symbol = (turn % 2).zero? ? @player2.symbol : @player1.symbol
      puts "#{@players.find { |player| player.symbol == symbol }.name} turn"

      begin
        @grid.add_symbol(gets.chomp.capitalize, symbol)
        puts `clear` # Clear screen after a valid move
        @grid.display_grid
      rescue StandardError => e
        puts e
        puts 'Pick again'
      else
        check_game_state
      end
    end

    announce_winner(winner)
  end

  def reset_game
    display_stalemate
    clear_board
  end

  def display_stalemate
    puts `clear`
    @grid.display_grid
    puts 'We reached a stalemate lets reset the table'
    sleep 3
  end

  def clear_board
    @grid = Grid.new
    @grid.display_grid
  end

  def check_game_state
    reset_game if @grid.isFull?
  end

  def announce_winner(winner)
    player_winner = @players.find { |player| player.symbol == winner }
    puts 'We have a winner!'
    puts "Congratulations #{player_winner.name}"
  end
end

game = Game.new
game.play
