# queen chess piece class
class Queen < Piece
  def symbol
    '♛'
  end

  def dest_coord_map(start_coord, board)
    Path.new(start_coord, board)
        .upwards.downwards.leftwards.rightwards.up_left.up_right.down_right.down_left
        .to_coord_map
  end
end
