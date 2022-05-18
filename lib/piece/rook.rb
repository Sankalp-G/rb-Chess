require_relative '../piece'

# rook chess piece class
class Rook < Piece
  def initialize(color)
    @color = color
    @symbol = '♜'
  end
end
