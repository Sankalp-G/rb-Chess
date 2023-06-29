# class dictating main game flow
class Chess
  def start
    main_menu
  end

  def main_menu
    main_menu_prompt

    case get_player_input_between(1, 3)
    when 1 then new_game and start_game_loop
    when 2 then clear_terminal and load_menu
    when 3 then exit
    end
  end

  def new_game
    @active_player = :white
    @board = Board.new
    self
  end

  def start_game_loop
    until game_over?
      Turn.new(@board, @active_player).play
      promote_pawns if pawn_promotion?
      @board.save_to_history
      switch_player
    end

    redraw_board
    display_game_over_prompt
    game_over_menu
  end

  def game_over_menu
    puts
    puts '[1] Main menu'
    puts '[2] New game'
    puts '[3] Exit'

    case get_player_input_between(1, 3)
    when 1 then main_menu
    when 2 then new_game and start_game_loop
    when 3 then exit
    end
  end

  def load_menu
    saves = Dir.children('./saves/')
    if saves.empty?
      puts "No saves found\nPress enter to go back"
      gets
      main_menu
    end

    puts "Select which save file you would like to load: \n\n"
    saves.each_with_index { |save, index| puts "#{index + 1}] #{save}" }

    selected_index = get_player_input_between(1, saves.length) - 1
    load_save("./saves/#{saves[selected_index]}")
  end

  def load_save(save_location)
    file_content = File.binread(save_location)
    save_object = Marshal.load(file_content)

    @active_player = save_object[:active_player]
    @board = save_object[:board]
    start_game_loop
  end

  def save_game_state
    save_object = { board: @board, active_player: @active_player }
    save_data = Marshal.dump(save_object)

    current_time = Time.now
    file_name = current_time.strftime('%H-%M %d-%m-%y')

    FileUtils.mkdir('./saves') unless File.directory?('./saves')

    File.write("./saves/#{file_name}", save_data, mode: 'wb')
  end

  def game_over?
    checkmate? || stalemate? || threefold_repetition? || _50_move_rule? || insufficient_material?
  end

  def display_game_over_prompt
    if checkmate?
      winner = @active_player == :white ? :black : :white
      puts "\n#{winner} player wins by checkmate! Congratulations."
    elsif stalemate?
      puts "\nThe game is tied by stalemate! Since #{active_player} has no possible moves."
    elsif threefold_repetition?
      puts "\nThe game is tied by threefold repetition! Since the same board state has occured three times."
    elsif _50_move_rule?
      puts "\nThe game is tied due to the 50 move rule!
Since no pawn has been moved or piece been captured in the last 50 moves."
    elsif insufficient_material?
      puts "\nThe game is tied due to insufficient material!
Since neither player has sufficient material to checkmate the other."
    end
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

  def threefold_repetition?
    repetitions = 0
    @board.history.history_arr.reverse.each do |board|
      repetitions += 1 if board == @board
      return true if repetitions >= 3
    end
    false
  end

  def _50_move_rule?
    return false if @board.history.history_arr.length < 50

    (last_time_piece_captured.nil? || last_time_piece_captured >= 50) &&
      (last_time_pawn_moved.nil? || last_time_pawn_moved >= 50)
  end

  def pawn_promotion?
    @board.board_arr[0].any? { |piece| piece.is_a?(Pawn) } ||
      @board.board_arr[7].any? { |piece| piece.is_a?(Pawn) }
  end

  def promote_pawns
    @board.board_arr.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        next unless piece.is_a?(Pawn) && (row_index.zero? || row_index == 7)

        @board.place_object_at_coord(promote_pawn_prompt(piece.color), CoordPair.new(row_index, col_index))
      end
    end
  end

  def insufficient_material?
    insufficient_material_for_color?(:white) && insufficient_material_for_color?(:black)
  end

  def insufficient_material_for_color?(color)
    [{ King: 1 }, { King: 1, Bishop: 1 }, { King: 1, Knight: 1 }].include?(@board.piece_count_hash_for_color(color))
  end

  private

  def promote_pawn_prompt(color)
    puts "\nYour pawn has reached the end of the board! What would you like to promote it to?"
    puts '[1] Queen'
    puts '[2] Rook'
    puts '[3] Bishop'
    puts '[4] Knight'

    case get_player_input_between(1, 4)
    when 1 then Queen.new(color)
    when 2 then Rook.new(color)
    when 3 then Bishop.new(color)
    when 4 then Knight.new(color)
    end
  end

  def last_time_piece_captured
    @board.history.history_arr.reverse.each_with_index do |board, index|
      return index if @board.piece_count < board.piece_count
    end
    nil
  end

  def last_time_pawn_moved
    @board.history.history_arr.reverse.each_with_index do |board, index|
      return index if pawn_positions(@board) != pawn_positions(board)
    end
    nil
  end

  def pawn_positions(board)
    pawn_positions = []
    board.board_arr.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        pawn_positions << CoordPair.new(row_index, col_index) if piece.is_a?(Pawn)
      end
    end
    pawn_positions
  end

  def move_map_arr_for_player(player_color)
    @board.all_moves_arr.filter do |move_map|
      move_piece = @board.piece_at_coord(move_map.start_coord)
      move_piece.color == player_color
    end
  end

  def redraw_board
    clear_terminal
    @board.display.prints
  end

  def clear_terminal
    system('clear') || system('cls')
  end

  def main_menu_prompt
    clear_terminal
    puts chess_ascii_art
    puts "\nWelcome to Chess!"
    puts "\nChoose one of the the following options:"
    puts '[1] New game'
    puts '[2] Load game'
    puts '[3] Exit'
  end

  def chess_ascii_art
    <<~CHESS
      ░█████╗░██╗░░██╗███████╗░██████╗░██████╗
      ██╔══██╗██║░░██║██╔════╝██╔════╝██╔════╝
      ██║░░╚═╝███████║█████╗░░╚█████╗░╚█████╗░
      ██║░░██╗██╔══██║██╔══╝░░░╚═══██╗░╚═══██╗
      ╚█████╔╝██║░░██║███████╗██████╔╝██████╔╝
      ░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
    CHESS
  end

  # gets input from terminal and returns input as integer, retries if invalid
  def get_player_input_between(start_num, end_num)
    loop do
      input = gets.chomp.to_i

      return input if input.between?(start_num, end_num)

      puts "\nInvalid Input: you must enter a number between #{start_num} and #{end_num}, Try again"
    end
  end
end
