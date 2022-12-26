# class handling chess board info
class Board
  include BoardConstants
  attr_reader :history

  def initialize
    @board_arr = default_chess_board
    @history = History.new(self)
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
    board_clone.instance_variable_set(:@history, @history)
    board_clone
  end

  def save_to_history
    @history.save_board(self)
  end

  def display
    BoardDisplay.new(@board_arr)
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

  def move_piece_from_to(start_coord, destination_coord)
    moving_piece = piece_at_coord(start_coord)
    place_object_at_coord(Unoccupied.new, start_coord)
    place_object_at_coord(moving_piece, destination_coord)
  end

  def moves_for_coord(coord_pair)
    piece = piece_at_coord(coord_pair)
    piece.valid_move_map(coord_pair, self)
  end

  def coord_is_targeted?(coord)
    all_moves_arr.any? { |move| move.can_target_coord?(coord) }
  end

  def limited_coord_is_targeted?(coord)
    @board_arr.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        piece_coord = CoordPair.new(row_index, col_index)
        moves = piece.limited_move_map(piece_coord, self)

        return true if moves.can_target_coord?(coord)
      end
    end
    false
  end

  def kings
    @board_arr.flatten.select { |piece| piece.is_a?(King) }
  end

  def check
    kings.each do |king|
      king_coord = find_coord_of_piece(king)
      return king.color if limited_coord_is_targeted?(king_coord)
    end
    nil
  end

  def all_moves_arr
    move_map_arr = []
    @board_arr.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        piece_coord = CoordPair.new(row_index, col_index)
        move_map_arr << piece.valid_move_map(piece_coord, self)
      end
    end
    move_map_arr
  end
end
