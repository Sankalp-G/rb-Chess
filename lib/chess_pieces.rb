# frozen_string_literal: true

require 'colorize'

# class containing chess piece class and common methods
class Piece
  attr_reader :color

  # returns a colorized chess piece symbol
  def colored_symbol
    " #{@symbol.colorize(@color.to_sym)} "
  end

  def with_bg_color(color)
    colored_symbol.colorize(background: color.to_sym)
  end
end

### All chess piece classes

# class for empty tiles
class Unoccupied < Piece
  def initialize(_color = nil)
    @symbol = ' '
  end

  def colored_symbol
    '   '
  end
end

# pawn chess piece class
class Pawn < Piece
  def initialize(color)
    @color = color
    @symbol = '♟'
  end
end

# knight chess piece class
class Knight < Piece
  def initialize(color)
    @color = color
    @symbol = '♞'
  end
end

# bishop chess piece class
class Bishop < Piece
  def initialize(color)
    @color = color
    @symbol = '♝'
  end
end

# rook chess piece class
class Rook < Piece
  def initialize(color)
    @color = color
    @symbol = '♜'
  end
end

# queen chess piece class
class Queen < Piece
  def initialize(color)
    @color = color
    @symbol = '♛'
  end
end

# king chess piece class
class King < Piece
  def initialize(color)
    @color = color
    @symbol = '♚'
  end
end
