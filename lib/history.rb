# saves previous board states as history
class History
  def initialize
    @history_arr = []
  end

  def save_board(board)
    @history_arr << board.clone
  end
end
