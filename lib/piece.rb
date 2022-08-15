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

  def get_valid_move_map(start_coord, _board)
    MoveMap.new(start_coord, CoordMap.from_2d_array([]))
  end
end
