# class to determine castling moves
class Castling
  def initialize(start_coord, board)
    @king_coord = start_coord
    @board = board
  end

  def move_arr
    moves = []
    moves << left_castle_move if can_castle_left?
    moves << right_castle_move if can_castle_right?
    moves
  end

  def left_castle_move
    king_move = Move.new(@king_coord, @king_coord.offset_by(0, -2))
    rook_move = Move.new(left_rook_coord, left_rook_coord.offset_by(0, 3))
    king_move.secondary_move = rook_move
    king_move
  end

  def can_castle_left?
    return false unless left_rook.is_a?(Rook)
    return false unless coords_unoccupied?(left_between_coords)
    return false if @board.history.piece_moved?(king) || @board.history.piece_moved?(left_rook)
    return false if enemy_can_target_coords?(left_king_path_coords)

    true
  end

  def right_castle_move
    king_move = Move.new(@king_coord, @king_coord.offset_by(0, 2))
    rook_move = Move.new(right_rook_coord, right_rook_coord.offset_by(0, -2))
    king_move.secondary_move = rook_move
    king_move
  end

  def can_castle_right?
    return false unless right_rook.is_a?(Rook)
    return false unless coords_unoccupied?(right_between_coords)
    return false if @board.history.piece_moved?(king) || @board.history.piece_moved?(right_rook)
    return false if enemy_can_target_coords?(right_king_path_coords)

    true
  end

  private

  def king
    @board.piece_at_coord(@king_coord)
  end

  def king_color
    king.color
  end

  def left_rook_coord
    @king_coord.offset_by(0, -4)
  end

  def left_rook
    @board.piece_at_coord(left_rook_coord)
  end

  def left_king_path_coords
    CoordMap.from_2d_array([[0, 0], [0, -1], [0, -2]])
            .all_add(@king_coord)
            .coord_arr
  end

  # coords between the king and the rook
  def left_between_coords
    CoordMap.from_2d_array([[0, -1], [0, -2], [0, -3]])
            .all_add(@king_coord)
            .coord_arr
  end

  def right_rook_coord
    @king_coord.offset_by(0, 3)
  end

  def right_rook
    @board.piece_at_coord(right_rook_coord)
  end

  def right_king_path_coords
    CoordMap.from_2d_array([[0, 0], [0, 1], [0, 2]])
            .all_add(@king_coord)
            .coord_arr
  end

  # coords between the king and the rook
  def right_between_coords
    CoordMap.from_2d_array([[0, 1], [0, 2]])
            .all_add(@king_coord)
            .coord_arr
  end

  def enemy_can_target_coords?(coord_arr)
    test_board = @board.clone
    # place pieces of same color as king so only enemies can target these coords
    coord_arr.each { |coord| test_board.place_object_at_coord(Pawn.new(king_color), coord) }
    coord_arr.any? { |coord| test_board.limited_coord_is_targeted?(coord) }
  end

  def coords_unoccupied?(coord_arr)
    coord_arr.all? { |coord| @board.piece_at_coord(coord).is_a?(Unoccupied) }
  end
end
