# group of two (x and y) coordinates
class CoordPair
  attr_accessor :x, :y

  def initialize(x_coord, y_coord)
    raise 'coordinates must be a number' unless x_coord.is_a?(Numeric) && y_coord.is_a?(Numeric)

    @x = x_coord
    @y = y_coord
  end

  def self.from_array(coord_array)
    CoordPair.new(coord_array[0], coord_array[1])
  end

  def to_array
    [@x, @y]
  end

  def +(other)
    raise 'coord can only be added to another coord' unless other.is_a?(CoordPair)

    added_x = @x + other.x
    added_y = @y + other.y
    CoordPair.new(added_x, added_y)
  end
end
