# saves previous board states as history
class History
  attr_reader :history_arr

  def initialize(initial_board = nil)
    @history_arr = []
    @history_arr << BoardClone.new(initial_board) unless initial_board.nil?
  end

  def save_board(board)
    @history_arr << BoardClone.new(board)
  end

  def piece_moved?(piece)
    last_coord = @history_arr.last.find_coord_of_piece(piece)
    !@history_arr.all? do |board|
      board.find_coord_of_piece(piece) == last_coord
    end
  end

  def previous_board
    @history_arr[-2]
  end
end
