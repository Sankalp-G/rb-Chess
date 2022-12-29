# class used to output board to terminal
class BoardDisplay
  using ColorableString

  def initialize(board_arr)
    @board_arr = board_arr
    @symbol_arr = generate_colored_symbols(board_arr)
    add_background_color(@symbol_arr)
  end

  def highlight_move_map(move_map)
    highlight_coord(move_map.start_coord, :gray_highlight)

    move_map.each_move do |move|
      dest_coord = move.destination_coord
      if coord_unoccupied?(dest_coord)
        highlight_unoccupied_coord(dest_coord)
      else
        highlight_coord(dest_coord, :red_highlight)
      end
    end
    self
  end

  def highlight_coord(coord_pair, color = :light_highlight)
    @symbol_arr[coord_pair.x][coord_pair.y].replace_bg_color(color)
    self
  end

  def highlight_unoccupied_coord(coord_pair)
    coord_sum = coord_pair.x + coord_pair.y
    if coord_sum.odd?
      highlight_coord(coord_pair, :dark_highlight)
    else
      highlight_coord(coord_pair, :light_highlight)
    end
  end

  def coord_unoccupied?(coord_pair)
    return true if @board_arr[coord_pair.x][coord_pair.y].is_a?(Unoccupied)
  end

  def prints
    @symbol_arr.each_with_index do |row, index|
      print(8 - index, ' ') # number column

      row.each { |symbol| print symbol }
      puts
    end
    puts alphabet_row
  end

  def alphabet_row
    ('a'..'h').to_a.join('  ').prepend('   ')
  end

  def add_background_color(symbol_arr)
    bg_cycle = %i[dark_tile light_tile].cycle

    symbol_arr.map! do |row|
      bg_cycle.next
      row.map { |symbol| symbol.bg_color(bg_cycle.next) }
    end
  end

  def generate_colored_symbols(board_arr)
    board_arr.map do |row|
      row.map do |piece|
        " #{piece.symbol.fg_color(piece.color)} "
      end
    end
  end
end
