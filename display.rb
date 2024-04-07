require_relative 'grid'
class Display
  def initialize(grid_obj)
    @row_labels = (1..grid_obj.rows).to_a
    @column_labels = ('A'..'Z').first(grid_obj.column)
    @header_row = build_row(@column_labels)
    @border_row = build_row(Array.new(grid_obj.column), is_border: true)
    @info_row1 = build_row(grid_obj.grid[0])

    puts build_full(grid_obj)
  end

  private

  def indentation(row_label)
    "     #{row_label} "
  end

  BORDER_GRID_CELL = '---|'.freeze

  def cell_display(info = ' ')
    " #{info} |"
  end

  def border_display
    '---|'
  end

  def build_row(row_data, row_label = ' ', is_border: false)
    row = indentation(row_label)
    if is_border
      row_data.each { row.concat(border_display) }
    else
      row_data.each { |cell_info| row.concat(cell_display(cell_info)) }
    end
    row.chomp('|')
  end

  def build_full(grid_obj)
    full_display = []
    full_display.append(@header_row, @border_row)
    grid_obj.grid.each_with_index do |row, index|
      row_label = (grid_obj.grid.size - index)
      full_display.append(build_row(row, row_label))
      full_display.append(@border_row)
    end
    full_display.pop
    full_display
  end
end

Display.new(Grid.new(5, 5))
