# frozen_string_literal: true

class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

# GamePlayerInterface
module GamePlayerInterface
  def game_introduction
    'Welcome, this is a simple tic tac toe console game, hope that you  like it!'
  end

  def get_player_name(player_number)
    puts "Please input the Player#{player_number} name :"
    gets.chomp
  end

  def greeting_player(player_object)
    puts "Hello #{player_object.name} , your weapon is '#{player_object.symbol}'"
  end
end
