# require all chess pieces
pieces = %w[unoccupied pawn knight bishop rook queen king]
pieces.each { |piece| require_relative "./piece/#{piece}" }

# constant units for board class
module BoardConstants
  # 2d array of pieces representing a normal chess board
  def default_chess_board
    [king_row_of_color('black'),
     pawn_row_of_color('black'),
     *Array.new(4) { empty_row },
     pawn_row_of_color('white'),
     king_row_of_color('white')]
  end

  # array of classes for the first row of a chess board
  def king_row_of_color(color)
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].map { |piece| piece.new(color) }
  end

  # array of a row of pawns
  def pawn_row_of_color(color)
    Array.new(8) { Pawn.new(color) }
  end

  # array of unoccupied classes
  def empty_row
    Array.new(8) { Unoccupied.new }
  end
end
