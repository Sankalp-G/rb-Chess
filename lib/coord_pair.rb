# group of two (x and y) coordinates
class CoordPair
  attr_accessor :x, :y

  def initialize(x_coord, y_coord)
    @x = x_coord
    @y = y_coord
  end

  def self.from_array(coord_array)
    CoordPair.new(coord_array[0], coord_array[1])
  end

  # checks if coord is within the bounds of a chess board
  def in_bounds?
    return true if @x.between?(0, 7) && @y.between?(0, 7)

    false
  end

  def to_array
    [@x, @y]
  end

  def offset_by(x_offset, y_offset)
    CoordPair.new(@x + x_offset, @y + y_offset)
  end

  def +(other)
    added_x = @x + other.x
    added_y = @y + other.y
    CoordPair.new(added_x, added_y)
  end

  def ==(other)
    @x == other.x && @y == other.y
  end
end
