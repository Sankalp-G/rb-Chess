require_relative '../piece'

# pawn chess piece class
class Pawn < Piece
  def initialize(color)
    @color = color
    @symbol = '♟'
  end
end
