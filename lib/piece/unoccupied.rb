# class for empty tiles
class Unoccupied < Piece
  def initialize(_color = nil)
    @color = color
  end

  def colored_symbol
    '   '
  end

  def symbol
    ' '
  end
end
