# frozen_string_literal: true

require_relative 'player'
require_relative 'grid'

# Game class will initialize the game handle all rounds and check for winning conditions
class Game
  include GamePlayerInterface

  attr_reader :grid, :players

  def initialize(_player1 = Player.new(get_player_name(1), 'x'),
                 _player2 = Player.new(get_player_name(2), 'o'),
                 _grid = Grid.new,
                 _turn = 1)
    @player1 = Player.new(get_player_name(1), 'x')
    @player2 = Player.new(get_player_name(2), 'o')
    @players = [@player1, @player2]
    @grid = Grid.new
    @grid.display_grid
    @turn = 0
  end

  def reset_game
    puts `clear`
    @grid.display_grid
    puts 'We reached a stale lets reset the table'
    sleep 3
    @grid = Grid.new
    @turn = 0
  end

  def play
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
    if @turn >= @grid.rows * @grid.column
      reset_game
      @turn = 1
    end
    @turn
  end

  def announce_winner(winner)
    player_winner = @players.find { |player| player.symbol == winner }
    puts 'We have a winner!'
    puts "Congratulations #{player_winner.name}"
  end
end

game = Game.new
game.play
