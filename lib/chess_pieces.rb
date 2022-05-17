# frozen_string_literal: true

require 'colorize'

# module containing chess piece class and common methods
module ChessPieces
  # returns a colorized chess piece symbol
  def colored_symbol
    @symbol.colorize(@color.to_sym)
  end

  def self.default_chess_board
    [king_row_of_color('black'),
     pawn_row_of_color('black'),
     *Array.new(4) { empty_row },
     pawn_row_of_color('white'),
     king_row_of_color('white')]
  end

  # array of classes for the first row of a chess board
  def self.king_row_of_color(color)
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].map { |piece| piece.new(color) }
  end

  # array of a row of pawns
  def self.pawn_row_of_color(color)
    Array.new(8) { Pawn.new(color) }
  end

  # array of unoccupied classes
  def self.empty_row
    Array.new(8) { Unoccupied.new }
  end

  ### All chess piece classes

  attr_reader :color

  # class for empty tiles
  class Unoccupied
    include ChessPieces

    def initialize(_color = nil)
      @symbol = ' '
    end

    def colored_symbol
      @symbol
    end
  end

  # pawn chess piece class
  class Pawn
    include ChessPieces

    def initialize(color)
      @color = color
      @symbol = '♟'
    end
  end

  # knight chess piece class
  class Knight
    include ChessPieces

    def initialize(color)
      @color = color
      @symbol = '♞'
    end
  end

  # bishop chess piece class
  class Bishop
    include ChessPieces

    def initialize(color)
      @color = color
      @symbol = '♝'
    end
  end

  # rook chess piece class
  class Rook
    include ChessPieces

    def initialize(color)
      @color = color
      @symbol = '♜'
    end
  end

  # queen chess piece class
  class Queen
    include ChessPieces

    def initialize(color)
      @color = color
      @symbol = '♛'
    end
  end

  # king chess piece class
  class King
    include ChessPieces

    def initialize(color)
      @color = color
      @symbol = '♚'
    end
  end
end
