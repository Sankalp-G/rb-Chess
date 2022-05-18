# frozen_string_literal: true

require_relative 'chess_pieces'

# class handling chess board info
class Board
  attr_reader :board

  def initialize
    @board = default_chess_board
  end

  def display_board(board = colorized_board)
    board.each do |row|
      row.each { |tile| print tile }
      puts
    end
  end

  def default_chess_board
    [king_row_of_color('black'),
     pawn_row_of_color('black'),
     *Array.new(4) { empty_row },
     pawn_row_of_color('white'),
     king_row_of_color('white')]
  end

  private

  # returns default colorized symbols and backgrounds from the board
  def colorized_board
    background_cycle = %w[red blue].cycle

    @board.map do |row|
      background_cycle.next
      row.map { |piece| piece.with_bg_color(background_cycle.next) }
    end
  end

  # array of classes for the first row of a chess board
  def king_row_of_color(color)
    [ChessPieces::Rook, ChessPieces::Knight, ChessPieces::Bishop, ChessPieces::Queen,
     ChessPieces::King, ChessPieces::Bishop, ChessPieces::Knight, ChessPieces::Rook]
      .map { |piece| piece.new(color) }
  end

  # array of a row of pawns
  def pawn_row_of_color(color)
    Array.new(8) { ChessPieces::Pawn.new(color) }
  end

  # array of unoccupied classes
  def empty_row
    Array.new(8) { ChessPieces::Unoccupied.new }
  end
end
