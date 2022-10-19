# describes point to point(s) movement on the chess board
class Move
  attr_reader :start_coord, :destination_coord
  # secondary move executes along with the main move,
  # deletion coord specifies a coord to be deleted when move is executed
  attr_accessor :secondary_move, :deletion_coord

  def initialize(start_coord, destination_coord)
    @start_coord = start_coord
    @destination_coord = destination_coord
  end

  def execute_on_board(board)
    board.move_piece_from_to(@start_coord, @destination_coord)

    secondary_move&.execute_on_board(board)
    board.place_object_at_coord(Unoccupied.new, deletion_coord) unless deletion_coord.nil?
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

  def endangers_king?(board)
    moving_piece = board.piece_at_coord(@start_coord)
    test_board = board.clone
    execute_on_board(test_board)
    return true if test_board.check == moving_piece.color

    false
  end

  def ==(other)
    @start_coord == other.start_coord && @destination_coord == other.destination_coord
  end
end
