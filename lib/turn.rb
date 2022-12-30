# class handling interactions for a single turn for one player in chess
class Turn
  def initialize(board, active_player)
    @board = board
    @active_player = active_player
  end

  def play
    # display board
    # get coord from player
    # select piece on coord
    # display viable moves
    # select move from destination coord from user
    # play move on board
  end

  def query_coord_from_player
    loop do
      input = gets.chomp
      letter = input[0].downcase
      number = input[1].to_i

      unless ('a'..'h').include?(letter) && (1..8).include?(number)
        puts "\nInvalid Coord. Input must be in algebraic notation Eg: a1 c3 d6\nTry Again\n"
        next
      end

      return CoordPair.from_algebraic_notation(input)
    end
  end
end
