require_relative '../piece'

# bishop chess piece class
class Bishop < Piece
  def initialize(color)
    @color = color
    @symbol = '♝'
  end
end
