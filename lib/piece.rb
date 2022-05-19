require 'colorize'

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
end
