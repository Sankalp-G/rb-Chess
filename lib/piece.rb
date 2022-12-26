# class containing chess piece class and common methods
class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def valid_move_map(start_coord, board)
    limited_move_map(start_coord, board).remove_self_checks(board)
  end

  # for cases where piece can move even while possibly endangering their own king
  def limited_move_map(start_coord, board)
    MoveMap.new(start_coord, dest_coord_map(start_coord, board))
           .remove_friendly_fire(board)
  end

  def dest_coord_map(_start_coord, _board)
    CoordMap.from_2d_array([])
  end
end
