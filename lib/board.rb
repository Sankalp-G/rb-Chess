# class handling chess board info
class Board
  include BoardConstants
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

  def piece_at_coord(coord_pair)
    return nil if coord_pair.x.negative? || coord_pair.y.negative?
    return nil if @board[coord_pair.x].nil?

    @board[coord_pair.x][coord_pair.y]
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
end
