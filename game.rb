# frozen_string_literal: true

# GamePlayerInterface
module GamePlayerInterface
  def game_introduction
    'Welcome, this is a simple tic tac toe console game, hope that you  like it!'
  end

  def get_player_name(player_number)
    return "player #{player_number}"
    puts "Please input the Player#{player_number} name :"
    gets.chomp
  end

  def greeting_player(player_object)
    puts "Hello #{player_object.name} , your weapon is '#{player_object.symbol}'"
  end
end

require_relative 'player'
require_relative 'grid'

# Game class will initialize the game handle all rounds and check for winning conditions
class Game
  include GamePlayerInterface

  attr_reader :grid

  def initialize
    # @player1 = Player.new(get_player_name(1), 'x')
    # @player2 = Player.new(get_player_name(2), 'o')
    @grid = Grid.new(5, 5)
    # @grid.display_grid
  end

  def play
    # check if we have a winning condition
    # if not request input from player x
    @grid.display_grid
    p @grid
    @grid.add_symbol('A3', 'x')
    @grid.add_symbol('B2', 'x')
    @grid.add_symbol('C1', 'x')
    @grid.add_symbol('C3', '0')
    @grid.add_symbol('D4', '0')
    @grid.add_symbol('E5', '0')

    @grid.display_grid
    p @grid.horizontal_winner
  end
end

game = Game.new

game.play
