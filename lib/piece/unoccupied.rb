require_relative '../piece'

# class for empty tiles
class Unoccupied < Piece
  def initialize(_color = nil)
    @symbol = ' '
  end

  def colored_symbol
    '   '
  end
end
