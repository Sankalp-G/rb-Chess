# rook chess piece class
class Rook < Piece
  def symbol
    '♜'
  end

  def dest_coord_map(start_coord, board)
    Path.new(start_coord, board)
        .upwards.downwards.leftwards.rightwards
        .to_coord_map
  end
end
