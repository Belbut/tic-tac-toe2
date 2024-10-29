require_relative 'grid_coordinates'

class InputError < StandardError; end

module GridManipulation
  def add_symbol(raw_coordinate, symbol)
    decomposed_coordinate = GridCoordinates.raw_to_decomposed_coordinate(raw_coordinate)
    write_cell(decomposed_coordinate, symbol)
  end

  private

  def write_cell(decomposed_coordinate, symbol)
    x = decomposed_coordinate[:x]
    y = decomposed_coordinate[:y]

    raise InputError.new, 'That cell is outside of the board!' if outside_grid?(decomposed_coordinate)
    raise InputError.new, 'That cell is already filled' unless cell_empty?(decomposed_coordinate)

    @grid[x][y] = symbol
    @grid
  end

  def write_cell!(decomposed_coordinate, symbol)
    x = decomposed_coordinate[:x]
    y = decomposed_coordinate[:y]

    raise InputError.new, 'That cell is outside of the board!' if outside_grid?(decomposed_coordinate)

    @grid[x][y] = symbol
    @grid
  end

  def read_cell(decomposed_coordinate)
    x = decomposed_coordinate[:x]
    y = decomposed_coordinate[:y]

    @grid.dig(x, y)
  end

  def cell_empty?(decomposed_coordinate)
    read_cell(decomposed_coordinate) == ' '
  end

  def outside_grid?(decomposed_coordinate)
    x = decomposed_coordinate[:x]
    y = decomposed_coordinate[:y]

    y > rows || x > column
  end
end
