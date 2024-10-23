# frozen_string_literal: true

require_relative 'grid_coordinates'
require_relative 'grid_manipulation'
require_relative 'win_condition'
require_relative 'display'

class Grid
  attr_reader :grid , :rows, :column

  include GridCoordinates
  include GridManipulation
  include WinCondition
  include Display

  def initialize(rows = 3, column = 3)
    @rows = rows
    @column = column
    @grid = Array.new (rows) { Array.new(column, ' ') }
  end
end

