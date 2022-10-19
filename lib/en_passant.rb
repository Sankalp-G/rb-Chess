# class to generate en passant moves for pawns
class EnPassant
  def initialize(pawn_coord, board)
    @pawn_coord = pawn_coord
    @board = board
  end

  def move_arr
    moves = []
    moves << left_en_passant_move if can_en_passant_left?
    moves << right_en_passant_move if can_en_passant_right?
    moves
  end

  def can_en_passant_left?
    left_coord = @pawn_coord.offset_by(0, -1)
    return false unless tile_has_enemy_pawn?(left_coord, @board)

    left_piece = @board.piece_at_coord(left_coord)
    correct_position = @pawn_coord.offset_by(2 * direction_multiplier, -1)
    return false unless previous_piece_at_coord(correct_position) == left_piece

    true
  end

  def can_en_passant_right?
    right_coord = @pawn_coord.offset_by(0, 1)
    return false unless tile_has_enemy_pawn?(right_coord, @board)

    right_piece = @board.piece_at_coord(right_coord)
    correct_position = @pawn_coord.offset_by(2 * direction_multiplier, 1)
    return false unless previous_piece_at_coord(correct_position) == right_piece

    true
  end

  def left_en_passant_move
    destination_coord = @pawn_coord.offset_by(direction_multiplier, -1)
    move = Move.new(@pawn_coord, destination_coord)
    move.deletion_coord = @pawn_coord.offset_by(0, -1)
    move
  end

  def right_en_passant_move
    destination_coord = @pawn_coord.offset_by(direction_multiplier, 1)
    move = Move.new(@pawn_coord, destination_coord)
    move.deletion_coord = @pawn_coord.offset_by(0, 1)
    move
  end

  private

  def pawn_color
    pawn = @board.piece_at_coord(@pawn_coord)
    pawn.color
  end

  def direction_multiplier
    case pawn_color
    when :black then 1
    when :white then -1
    end
  end

  def tile_has_enemy?(coord, board)
    tile_piece = board.piece_at_coord(coord)
    return false if tile_piece.nil?
    return false if tile_piece.is_a?(Unoccupied)
    return false if tile_piece.color == pawn_color

    true
  end

  def tile_has_enemy_pawn?(coord, board)
    piece = board.piece_at_coord(coord)
    return false unless tile_has_enemy?(coord, board)
    return false unless piece.is_a?(Pawn)

    true
  end

  def previous_piece_at_coord(coord)
    previous_board = @board.history.previous_board
    previous_board.piece_at_coord(coord)
  end
end
