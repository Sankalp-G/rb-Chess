# A class used to make cloned versions of the main board to be used in history
class BoardClone < Board
  def initialize(board)
    base_arr = board.instance_variable_get(:@board_arr)
    @board_arr = base_arr.map(&:clone)
  end
end
