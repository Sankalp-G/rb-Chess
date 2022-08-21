# bishop chess piece class
class Bishop < Piece
  def symbol
    '♝'
  end

  def dest_coord_map(start_coord, board)
    Path.new(start_coord, board)
        .up_left.up_right.down_right.down_left
        .to_coord_map
  end
end
