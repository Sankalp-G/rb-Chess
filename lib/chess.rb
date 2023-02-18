# class dictating main game flow
class Chess
  def new_game
    @active_player = :white
    @board = Board.new
    self
  end

  def start_game_loop
    until game_over?
      Turn.new(@board, @active_player).play
      @board.save_to_history
      switch_player
    end

    # handle game over
  end

  def game_over?
    checkmate? || stalemate?
  end

  def switch_player
    @active_player = @active_player == :white ? :black : :white
  end

  def checkmate?
    return false unless @board.check

    move_map_arr_for_player(@active_player).each do |move_map|
      move_map.moves_arr.each do |move|
        test_board = @board.clone
        move.execute_on_board(test_board)

        return false unless test_board.check == @active_player
      end
    end
    true
  end

  def stalemate?
    move_map_arr_for_player(@active_player)
      .all? { |move_map| move_map.moves_arr.empty? }
  end

  def move_map_arr_for_player(player_color)
    @board.all_moves_arr.filter do |move_map|
      move_piece = @board.piece_at_coord(move_map.start_coord)
      move_piece.color == player_color
    end
  end
end
