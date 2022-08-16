# queen chess piece class
class Queen < Piece
  def symbol
    '♛'
  end

  def get_valid_move_map(start_coord, board)
    dest_coords = valid_dest_coord_map(start_coord, board)
    MoveMap.new(start_coord, dest_coords)
           .remove_friendly_fire(board)
  end

  def valid_dest_coord_map(start_coord, board)
    Path.new(start_coord, board)
        .upwards.downwards.leftwards.rightwards.up_left.up_right.down_right.down_left
        .to_coord_map
  end
end
