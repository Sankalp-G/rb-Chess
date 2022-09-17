# A collection of coord pairs
class CoordMap
  # create coord map from an array of coord pairs
  def initialize(coord_pair_array = [])
    @map = coord_pair_array
  end

  # create coord map from an array containing sub arrays made of x and y coordinates
  # e.g. [[1, 2], [3, -1], [21, 33]]
  def self.from_2d_array(array_2d)
    coord_pair_array = array_2d.map { |pair_array| CoordPair.from_array(pair_array) }
    CoordMap.new(coord_pair_array)
  end

  # add another coord pair to coord map
  def append(coord_pair)
    @map << coord_pair
    self
  end

  # add a coordinate pair to all pairs in coord map
  def all_add(coord_pair)
    @map.map! { |pair| pair + coord_pair }
    self
  end

  def ==(other)
    return false if length != other.length

    length.times do |i|
      return false if coord_at_index(i).x != other.coord_at_index(i).x
      return false if coord_at_index(i).y != other.coord_at_index(i).y
    end
    true
  end

  # removes all coords in coord map with are out of bounds of a chess board
  def remove_out_of_bounds
    @map = @map.filter(&:in_bounds?)
    self
  end

  def coord_at_index(index)
    @map[index]
  end

  def length
    @map.length
  end

  def each(&block)
    @map.each(&block)
  end
end
