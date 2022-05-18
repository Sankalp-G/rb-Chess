require_relative '../piece'

# queen chess piece class
class Queen < Piece
  def initialize(color)
    @color = color
    @symbol = '♛'
  end
end
