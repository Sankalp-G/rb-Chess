# combination of several moves originating from the same coord
class MoveMap
  attr_reader :start_coord, :moves_arr

  def initialize(start_coord, destination_coord_map)
    raise 'start_coord must be a coord pair' unless start_coord.is_a?(CoordPair)
    raise 'destination map must be a coord map' unless destination_coord_map.is_a?(CoordMap)

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

  def ==(other)
    return false if @moves_arr.length != other.moves_arr.length

    @moves_arr.length.times do |i|
      return false unless @moves_arr[i] == other.moves_arr[i]
    end
    true
  end

  def can_target_coord?(coord)
    dest_coord_map.each { |dest_coord| return true if dest_coord == coord }
    false
  end

  private

  def convert_to_moves(destination_coord_map)
    result = []
    destination_coord_map.each { |coord| result << Move.new(@start_coord, coord) }
    result
  end
end
