# class handling interactions for a single turn for one player in chess
class Turn
  using ColorableString

  def initialize(board, active_player)
    @board = board
    @active_player = active_player
    @state = :initial
    @prompt = nil

    @selected_coord = nil
    @selected_move = nil
    @coord = nil
  end

  def play
    loop do
      case @state
      when :initial
        display_game_screen
        select_piece_coord
      when :coord_selected
        display_game_screen
        select_piece_move
      when :move_selected
        return @selected_move.execute_on_board(@board)
      end
    end
  end

  def select_piece_coord
    print "\n[x] exit [s] save and exit\n\nSelect the piece you would like to move:\n\n> "

    gets_player_input and return

    invalid_piece_color?(@coord) and return

    @state = :coord_selected
    @selected_coord = @coord
  end

  def select_piece_move
    moves = @board.moves_for_coord(@selected_coord)
    no_valid_moves?(moves) and return

    print "\n[b] go back [x] exit [s] save and exit\n
Select the tile where you would like to move the piece to.\n\n> "

    gets_player_input and return

    move = moves.select_by_dest_coord(@coord)
    invalid_move?(move) and return

    @state = :move_selected
    @selected_move = move
  end

  # runs input command or sets given input coord as @coord instance variable
  # returns true if command is run or invalid prompt is displayed
  def gets_player_input
    input = gets.chomp

    if command?(input)
      run_command(input)
    elsif coord?(input)
      @coord = CoordPair.from_algebraic_notation(input)
      return false
    else
      @prompt = "\nInvalid Input.\nUse chess notation eg: c2\n"
    end
    true
  end

  def display_game_screen
    clear_terminal

    display = @board.display
    unless @selected_coord.nil?
      moves = @board.moves_for_coord(@selected_coord)
      display.highlight_move_map(moves)
    end
    display.prints

    print "\n#{@active_player.capitalize.to_s.bg_color(@active_player)} player turn\n"

    return if @prompt.nil?

    puts @prompt
    @prompt = nil
  end

  def invalid_move?(move)
    if move.nil?
      @prompt = "\nInvalid Destination Coord, Try Again\n"
      return true
    end
    false
  end

  def no_valid_moves?(moves)
    if moves.moves_arr.empty?
      @prompt = "\nSelected tile/piece has no valid moves\n"
      @state = :initial
      @selected_coord = nil
      return true
    end
    false
  end

  def invalid_piece_color?(coord)
    if @board.piece_at_coord(coord).color != @active_player
      @prompt = "\nYou have to select a piece of your own color.\n"
      return true
    end
    false
  end

  def run_command(command)
    if %w[b back].include?(command)
      @state = :initial
      @selected_coord = nil
      return true
    elsif %w[s save].include?(command)
      save_game_state
      exit
    elsif %w[x exit].include?(command)
      exit
    end
    false
  end

  def command?(string)
    %w[x exit s save b back].include?(string)
  end

  def coord?(string)
    return false if string.length != 2

    letter = string[0].downcase
    number = string[1].to_i
    ('a'..'h').include?(letter) && (1..8).include?(number)
  end

  def save_game_state
    save_object = { board: @board, active_player: @active_player }
    save_data = Marshal.dump(save_object)

    current_time = Time.now
    file_name = current_time.strftime('%H-%M %d-%m-%y')

    FileUtils.mkdir('./saves') unless File.directory?('./saves')

    File.write("./saves/#{file_name}", save_data, mode: 'wb')
  end

  def clear_terminal
    system('clear') || system('cls')
  end
end
