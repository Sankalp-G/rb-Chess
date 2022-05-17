# frozen_string_literal: true

# module containing chess piece class and common methods
module ChessPieces
  # all chess piece classes

  attr_reader :color, :symbol

  # class for empty tiles
  class Unoccupied
    def initialize(_color = nil)
      @symbol = ' '
    end
  end

  # pawn chess piece class
  class Pawn
    def initialize(color)
      @color = color
      @symbol = '♟'
    end
  end

  # knight chess piece class
  class Knight
    def initialize(color)
      @color = color
      @symbol = '♞'
    end
  end

  # bishop chess piece class
  class Bishop
    def initialize(color)
      @color = color
      @symbol = '♝'
    end
  end

  # rook chess piece class
  class Rook
    def initialize(color)
      @color = color
      @symbol = '♜'
    end
  end

  # queen chess piece class
  class Queen
    def initialize(color)
      @color = color
      @symbol = '♛'
    end
  end

  # king chess piece class
  class King
    def initialize(color)
      @color = color
      @symbol = '♚'
    end
  end
end
