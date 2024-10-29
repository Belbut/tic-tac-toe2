# frozen_string_literal: true

require_relative 'grid_coordinates'
require_relative 'grid_manipulation'
require_relative 'win_condition'
require_relative 'display'

class Grid
  attr_reader :grid

  extend GridCoordinates

  include GridManipulation
  include Display

  EMPTY_CELL = ' '

  def initialize(rows = 3, column = 3)
    @grid = Array.new(rows) { Array.new(column, EMPTY_CELL) }
  end

  def rows
    @grid.size
  end

  def column
    @grid[0].size
  end

  def occupied_cell_count
    @grid.flatten.count { |cell| cell != EMPTY_CELL }
  end

  def full?
    occupied_cell_count == size
  end

  def size
    rows * column
  end
end
