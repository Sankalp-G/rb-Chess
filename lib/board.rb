# class handling chess board info
class Board
  include BoardConstants
  attr_reader :board_arr

  def initialize
    @board_arr = default_chess_board
  end

  def clear_board
    @board_arr = blank_board
    self
  end

  def self.new_blank_board
    Board.new.clear_board
  end

  def clone
    board_arr_clone = @board_arr.map(&:clone)
    board_clone = Board.new
    board_clone.instance_variable_set(:@board_arr, board_arr_clone)
    board_clone
  end

  # placeholder for history object
  def history; end

  def display_board(board = colorized_board)
    board.each do |row|
      row.each { |tile| print tile }
      puts
    end
  end

  def find_coord_of_piece(piece)
    @board_arr.each_with_index do |row, row_index|
      col_index = row.index(piece)
      return CoordPair.new(row_index, col_index) unless col_index.nil?
    end
    nil
  end

  def piece_at_coord(coord_pair)
    return nil if coord_pair.x.negative? || coord_pair.y.negative?
    return nil if @board_arr[coord_pair.x].nil?

    @board_arr[coord_pair.x][coord_pair.y]
  end

  def place_object_at_coord(object, coord_pair)
    @board_arr[coord_pair.x][coord_pair.y] = object
  end

  def moves_for_coord(coord_pair)
    piece = piece_at_coord(coord_pair)
    piece.get_valid_move_map(coord_pair, self)
  end

  private

  # returns default colorized symbols and backgrounds from the board
  def colorized_board
    background_cycle = %w[red blue].cycle

    @board_arr.map do |row|
      background_cycle.next
      row.map { |piece| piece.with_bg_color(background_cycle.next) }
    end
  end
end
