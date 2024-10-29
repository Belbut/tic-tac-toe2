# frozen_string_literal: true

require_relative 'grid_coordinates'

module WinCondition
  include GridCoordinates

  def winner
    vertical_winner or horizontal_winner or diagonal_winner
  end

  private

  # will return the symbol of the winner or nil
  def winner_of_array(array)
    (array.size - @win_condition + 1).times do |i|
      return array[i] if array[i...(i + @win_condition)].uniq.count == 1 && array[i] != ' '
    end
    nil
  end

  def direction_winner(grid_obj)
    grid_obj.each do |row|
      winner = winner_of_array(row)
      return winner unless winner.nil?
    end
    nil
  end

  def vertical_winner
    direction_winner(@board.grid)
  end

  def horizontal_winner
    direction_winner(@board.grid.transpose)
  end

  def diagonal_winner
    direction_winner(all_sub_diagonals(@board.grid))
  end

  # only works with a [n x n] grid_array
  def all_sub_diagonals(grid_array)
    [*right_hand_diagonals(grid_array), *left_hand_diagonals(grid_array)]
  end

  def right_hand_diagonals(grid_array)
    combinations = generate_diagonal_combinations(grid_array)
    combinations.map do |line|
      line.map { |e| grid_array.dig(e[0], e[1]) }
    end
  end

  def left_hand_diagonals(grid_array)
    reverted_grid = grid_array.map(&:reverse)
    right_hand_diagonals(reverted_grid)
  end

  def generate_diagonal_combinations(grid_array)
    max = grid_array.size - 1
    number_of_sub_arrays = (2 * grid_array.size) - 1
    combinations = []
    number_of_sub_arrays.times do |diagonal_index|
      combinations.append(step_diagonal_combinations(diagonal_index, max))
    end

    combinations
  end

  def step_diagonal_combinations(diagonal_index, max)
    result = []
    initial_i = i = [diagonal_index, max].min
    j = diagonal_index - i

    loop do
      result.append([i, j])

      break if j == initial_i

      i -= 1
      j += 1
    end
    result
  end
end
