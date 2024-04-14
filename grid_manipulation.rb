require_relative 'grid_coordinates'

module GridManipulation
  include GridCoordinates

  def add_symbol(raw_coordinate, symbol)
    write_cell(raw_to_decomposed_coordinate(raw_coordinate), symbol)
  end

  private

  def write_cell(decomposed_coordinate, symbol)
    return Exception.new('That cell is already filled') unless read_cell(decomposed_coordinate) == ' '

    x = decomposed_coordinate[:x]
    y = decomposed_coordinate[:y]

    @grid[x][y] = symbol
    @grid
  end

  def read_cell(decomposed_coordinate)
    x = decomposed_coordinate[:x]
    y = decomposed_coordinate[:y]

    @grid.dig(x, y)
  end
end
