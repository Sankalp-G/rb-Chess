# frozen_string_literal: true

require_relative 'chess_pieces'

# class handling chess board info
class Board
  attr_reader :board

  def initialize
    @board = ChessPieces.default_chess_board
  end

  # returns default colorized symbols and backgrounds from the board
  def colorized_board
    background_cycle = %w[red blue].cycle

    @board.map do |row|
      background_cycle.next
      row.map { |piece| piece.with_bg_color(background_cycle.next) }
    end
  end

  def display_board(board = colorized_board)
    board.each do |row|
      row.each { |tile| print tile }
      puts
    end
  end
end
