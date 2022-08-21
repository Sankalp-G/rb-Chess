# class containing chess piece class and common methods
class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end

  # returns a colorized chess piece symbol
  def colored_symbol
    " #{symbol.colorize(@color.to_sym)} "
  end

  def with_bg_color(color)
    colored_symbol.colorize(background: color.to_sym)
  end

  def valid_move_map(start_coord, board)
    MoveMap.new(start_coord, dest_coord_map(start_coord, board))
           .remove_friendly_fire(board)
  end

  def dest_coord_map(_start_coord, _board)
    CoordMap.from_2d_array([])
  end
end
