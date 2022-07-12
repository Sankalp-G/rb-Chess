# rook chess piece class
class Rook < Piece
  def symbol
    '♜'
  end

  def get_valid_move_map(start_coord, board)
    dest_coords = valid_dest_coord_map(start_coord, board)
    MoveMap.new(start_coord, dest_coords)
  end

  def valid_dest_coord_map(start_coord, board)
    Path.new(start_coord, board)
        .upwards.downwards.leftwards.rightwards
        .to_coord_map
  end
end
