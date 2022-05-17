# frozen_string_literal: true

require_relative 'chess_pieces'

# class handling chess board info
class Board
  attr_reader :board

  def initialize
    @board = ChessPieces.default_chess_board
  end
end
