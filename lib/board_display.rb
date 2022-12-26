# class used to output board to terminal
class BoardDisplay
  using ColorableString

  def initialize(board_arr)
    @symbol_arr = generate_colored_symbols(board_arr)
    add_background_color(@symbol_arr)
  end

  def prints
    @symbol_arr.each do |row|
      row.each { |symbol| print symbol }
      puts
    end
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
