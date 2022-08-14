# saves previous board states as history
class History
  def initialize
    @history_arr = []
  end

  def save_board(board)
    @history_arr << board.clone
  end

  def piece_moved?(piece)
    last_coord = @history_arr.last.find_coord_of_piece(piece)
    !@history_arr.all? do |board|
      board.find_coord_of_piece(piece) == last_coord
    end
  end
end
