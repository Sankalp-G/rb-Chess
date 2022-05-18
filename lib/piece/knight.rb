require_relative '../piece'

# knight chess piece class
class Knight < Piece
  def initialize(color)
    @color = color
    @symbol = '♞'
  end
end
