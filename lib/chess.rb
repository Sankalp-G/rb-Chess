# class dictating main game flow
class Chess
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
      @board.save_to_history
      switch_player
    end

    redraw_board
    display_game_over_prompt
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
    checkmate? || stalemate?
  end

  def display_game_over_prompt
    if checkmate?
      winner = @active_player == :white ? :black : :white
      puts "\n#{winner} player wins by checkmate! Congratulations."
    elsif stalemate?
      puts "\nThe game is tied by stalemate! Since #{active_player} has no possible moves."
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
