# class used to output board to terminal
class BoardDisplay
  using ColorableString

  def initialize(board_arr)
    @symbol_arr = generate_colored_symbols(board_arr)
    add_background_color(@symbol_arr)
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
