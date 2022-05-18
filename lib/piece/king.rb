require_relative '../piece'

# king chess piece class
class King < Piece
  def initialize(color)
    @color = color
    @symbol = '♚'
  end
end
