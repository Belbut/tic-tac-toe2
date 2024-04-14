module GridCoordinates
  # Transforms from a "A2" to {x:1,y:2}
  def raw_to_decomposed_coordinate(raw_coordinate)
    row_index = raw_coordinate.delete('^0-9').to_i

    column_letter = raw_coordinate.scan(/\w/).first
    column_index = column_letter.ord % 65 # Calculate column index based on ASCII value

    { x: column_index, y: row_index - 1 }
  end

  # TODO: Transforms from {x:1,y:2} to "A2"
  def decomposed_to_raw_coordinate(decomposed_coordinate); end
end
