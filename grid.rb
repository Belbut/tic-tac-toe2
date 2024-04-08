# frozen_string_literal: true

require_relative 'display'

class Grid
  attr_reader :grid, :rows, :column

  include Display

  def initialize(rows = 3, column = 3)
    @rows = rows
    @column = column
    @grid = Array.new(rows, Array.new(column, ' '))
  end
end

grid = Grid.new(13, 13)

puts grid.display_data
