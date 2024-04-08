# frozen_string_literal: true

# Display module was made to Display in the terminal in a organized way the information of a grid
module Display
  def display_data
    full_display = []

    grid = self.grid
    full_display.append(generate_column_heading(grid))
    full_display.append(*generate_rows_with_border(grid))
    full_display.append(generate_column_heading(grid))

    puts full_display
  end

  private

  def generate_column_heading(grid)
    column_labels = ('A'..'Z').first(grid.size)
    build_row(column_labels, is_heading: true)
  end

  def generate_border_row(grid)
    build_row(Array.new(grid.size), is_border: true)
  end

  def generate_rows_with_border(grid)
    rows_with_border = []
    border_row = generate_border_row(grid)

    grid.each_with_index do |row, index|
      row_label = (grid.size - index)
      rows_with_border.append(build_row(row, row_label))
      rows_with_border.append(border_row)
    end
    rows_with_border.pop # remove last border row
    rows_with_border
  end

  def left_indentation(row_label)
    row_label = "#{row_label} "
    row_label.rjust(8) # left padding
  end

  def right_indentation(row_label)
    row_label = " #{row_label}"
    row_label.ljust(8) # left padding
  end

  BORDER_GRID_CELL = '---|'

  def cell_display(is_heading, info = ' ')
    if is_heading
      " #{info}  "
    else
      " #{info} |"
    end
  end

  def border_display
    '---|'
  end

  def build_row(row_data, row_label = ' ', is_border: false, is_heading: false)
    row = left_indentation(row_label)
    if is_border
      row_data.each { row.concat(border_display) }
    else
      row_data.each { |cell_info| row.concat(cell_display(is_heading, cell_info)) }
    end
    row.chomp!('|')
    row.concat(right_indentation(row_label))
  end
end
