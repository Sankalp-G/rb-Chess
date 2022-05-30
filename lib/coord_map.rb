require_relative 'coord_pair'

# A collection of coord pairs
class CoordMap
  attr_reader :map

  # create coord map from an array of coord pairs
  def initialize(coord_pair_array = [])
    raise 'argument must be a an array of coord pairs' unless coord_pair_array.is_a?(Array)
    raise 'array must only contain coord pair objects' unless coord_pair_array.all? { |items| items.is_a?(CoordPair) }

    @map = coord_pair_array
  end

  # create coord map from an array containing sub arrays made of x and y coordinates
  # e.g. [[1, 2], [3, -1], [21, 33]]
  def self.from_2d_array(array_2d)
    raise 'argument must be a an array of coord sub arrays' unless array_2d.is_a?(Array)

    coord_pair_array = array_2d.map { |pair_array| CoordPair.from_array(pair_array) }
    CoordMap.new(coord_pair_array)
  end

  # add another coord pair to coord map
  def append(coord_pair)
    raise 'can only append coord pair object' unless coord_pair.is_a?(CoordPair)

    @map << coord_pair
  end

  # add a coordinate pair to all pairs in coord map
  def all_add(coord_pair)
    @map.map! { |pair| pair + coord_pair }
  end
end
