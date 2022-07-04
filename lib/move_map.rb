# combination of several moves originating from the same coord
class MoveMap
  attr_reader :start_coord, :moves

  def initialize(start_coord, destination_coord_map)
    raise 'start_coord must be a coord pair' unless start_coord.is_a?(CoordPair)
    raise 'destination map must be a coord map' unless destination_coord_map.is_a?(CoordMap)

    @start_coord = start_coord
    @moves = convert_to_moves(destination_coord_map)
  end

  def each_move(&block)
    @moves.each(&block)
  end

  def remove_friendly_fire(board)
    @moves.filter! { |move| !move.targeting_friendly?(board) }
    self
  end

  def dest_coord_map
    destination_coords = @moves.map(&:destination_coord)
    CoordMap.new(destination_coords)
  end

  def ==(other)
    return false if @moves.length != other.moves.length

    @moves.length.times do |i|
      return false unless @moves[i] == other.moves[i]
    end
    true
  end

  private

  def convert_to_moves(destination_coord_map)
    result = []
    destination_coord_map.each { |coord| result << Move.new(@start_coord, coord) }
    result
  end
end
