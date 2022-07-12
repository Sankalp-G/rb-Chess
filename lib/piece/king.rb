# king chess piece class
class King < Piece
  def symbol
    '♚'
  end

  def get_valid_move_map(start_coord, board)
    moves = MoveMap.new(start_coord, king_coords(start_coord))
    moves.remove_friendly_fire(board)
  end

  private

  def king_coords(start_coord)
    CoordMap.from_2d_array(relative_coord_arr)
            .all_add(start_coord)
            .remove_out_of_bounds
  end

  def relative_coord_arr
    [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [-1, 0], [1, -1]]
  end
end
