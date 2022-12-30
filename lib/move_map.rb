# combination of several moves originating from the same coord
class MoveMap
  attr_reader :start_coord, :moves_arr

  def initialize(start_coord, destination_coord_map)
    @start_coord = start_coord
    @moves_arr = convert_to_moves(destination_coord_map)
  end

  def each_move(&block)
    @moves_arr.each(&block)
  end

  def remove_friendly_fire(board)
    @moves_arr.filter! { |move| !move.targeting_friendly?(board) }
    self
  end

  def remove_self_checks(board)
    @moves_arr.filter! { |move| !move.endangers_king?(board) }
    self
  end

  def dest_coord_map
    destination_coords = @moves_arr.map(&:destination_coord)
    CoordMap.new(destination_coords)
  end

  def select_by_dest_coord(destination_coord)
    @moves_arr.find { |move| move.destination_coord == destination_coord }
  end

  def can_target_coord?(coord)
    dest_coord_map.each { |dest_coord| return true if dest_coord == coord }
    false
  end

  def ==(other)
    return false if @moves_arr.length != other.moves_arr.length

    @moves_arr.length.times do |i|
      return false unless @moves_arr[i] == other.moves_arr[i]
    end
    true
  end

  def append(move)
    @moves_arr << move
  end

  def concat_arr(moves_arr)
    @moves_arr += moves_arr
  end

  private

  def convert_to_moves(destination_coord_map)
    result = []
    destination_coord_map.each { |coord| result << Move.new(@start_coord, coord) }
    result
  end
end
