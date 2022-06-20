# describes point to point(s) movement on the chess board
class Move
  attr_reader :start_coord, :destination_coord

  def initialize(start_coord, destination_coord)
    raise 'coord arguments must be coord pair' unless start_coord.is_a?(CoordPair) && destination_coord.is_a?(CoordPair)

    @start_coord = start_coord
    @destination_coord = destination_coord
  end

  def in_bounds?
    return true if @start_coord.in_bounds? && @destination_coord.in_bounds?

    false
  end

  def targeting_friendly?(board)
    start_piece = board.piece_at_coord(start_coord)
    dest_piece = board.piece_at_coord(destination_coord)

    start_piece.color == dest_piece.color
  end

  def ==(other)
    @start_coord == other.start_coord && @destination_coord == other.destination_coord
  end
end
