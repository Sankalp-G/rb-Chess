# pawn chess piece class
class Pawn < Piece
  def symbol
    '♟'
  end

  def get_valid_move_map(start_coord, board)
    destination_coord_map = CoordMap.new(all_destination_coords(start_coord, board))
    MoveMap.new(start_coord, destination_coord_map)
  end

  private

  def all_destination_coords(start_coord, board)
    [step_coord(start_coord, board), leap_coord(start_coord, board),
     left_attack_coord(start_coord, board), right_attack_coord(start_coord, board)]
      .compact
  end

  def direction_multiplier
    case @color
    when 'black' then 1
    when 'white' then -1
    end
  end

  def step_coord(start_coord, board)
    possible_coord = start_coord.offset_by(direction_multiplier, 0)
    return possible_coord if board.piece_at_coord(possible_coord).is_a?(Unoccupied)

    nil
  end

  def leap_coord(start_coord, board)
    return nil if board.history.has_piece_moved(self)

    possible_coord = start_coord.offset_by(direction_multiplier * 2, 0)
    return possible_coord if step_coord(start_coord, board) && board.piece_at_coord(possible_coord).is_a?(Unoccupied)

    nil
  end

  def left_attack_coord(start_coord, board)
    possible_coord = start_coord.offset_by(direction_multiplier, -1)
    return possible_coord if tile_has_enemy?(possible_coord, board)

    nil
  end

  def right_attack_coord(start_coord, board)
    possible_coord = start_coord.offset_by(direction_multiplier, 1)
    return possible_coord if tile_has_enemy?(possible_coord, board)

    nil
  end

  def tile_has_enemy?(coord, board)
    tile_piece = board.piece_at_coord(coord)
    return false if tile_piece.nil?
    return false if tile_piece.is_a?(Unoccupied)
    return false if tile_piece.color == @color

    true
  end
end
