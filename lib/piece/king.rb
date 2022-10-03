# king chess piece class
class King < Piece
  def symbol
    '♚'
  end

  def limited_move_map(start_coord, board)
    castling_moves = Castling.new(start_coord, board).move_arr
    move_map = super(start_coord, board)
    move_map.concat_arr(castling_moves)
    move_map
  end

  def dest_coord_map(start_coord, _board)
    CoordMap.from_2d_array(relative_coord_arr)
            .all_add(start_coord)
            .remove_out_of_bounds
  end

  def relative_coord_arr
    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  end
end
