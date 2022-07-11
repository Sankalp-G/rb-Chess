# A path in the given directions from start coord and board
class Path
  def initialize(start_coord, board)
    @path = []
    @start_coord = start_coord
    @board = board
  end

  def upwards
    include_path_by_step(-1, 0)
    self
  end

  def downwards
    include_path_by_step(1, 0)
    self
  end

  def rightwards
    include_path_by_step(0, 1)
    self
  end

  def leftwards
    include_path_by_step(0, -1)
    self
  end

  def up_right
    include_path_by_step(-1, 1)
    self
  end

  def up_left
    include_path_by_step(-1, -1)
    self
  end

  def down_left
    include_path_by_step(1, -1)
    self
  end

  def down_right
    include_path_by_step(1, 1)
    self
  end

  def to_coord_map
    CoordMap.new(@path)
  end

  def include_path_by_step(x_step, y_step)
    path_coords = path_coord_array_by_step(x_step, y_step)
    filtered_path = filter_line_of_sight(path_coords)
    @path += filtered_path
  end

  def path_coord_array_by_step(x_step, y_step)
    result = []
    x_offset = x_step
    y_offset = y_step
    while @start_coord.offset_by(x_offset, y_offset).in_bounds?
      result << @start_coord.offset_by(x_offset, y_offset)
      x_offset += x_step
      y_offset += y_step
    end
    result
  end

  def filter_line_of_sight(coord_array)
    result = []
    coord_array.each do |coord|
      result << coord
      break unless @board.piece_at_coord(coord).is_a?(Unoccupied)
    end
    result
  end
end
