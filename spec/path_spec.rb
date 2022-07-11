require_relative '../lib/libraries'

describe Path do
  let(:default_board) { Board.new }
  let(:start_coord) { CoordPair.new(3, 4) }

  describe '#downwards' do
    it 'returns coord map with 4 coords' do
      down_path = described_class.new(start_coord, default_board).downwards

      expected_coords = CoordMap.from_2d_array([[4, 4], [5, 4], [6, 4]])
      expect(down_path.to_coord_map).to eq(expected_coords)
    end
  end

  describe '#rightwards' do
    it 'returns coord map with 3 coords' do
      right_path = described_class.new(start_coord, default_board).rightwards

      expected_coords = CoordMap.from_2d_array([[3, 5], [3, 6], [3, 7]])
      expect(right_path.to_coord_map).to eq(expected_coords)
    end
  end

  describe '#up_left' do
    it 'returns coord map with 3 coords' do
      up_left_path = described_class.new(start_coord, default_board).up_left

      expected_coords = CoordMap.from_2d_array([[2, 3], [1, 2]])
      expect(up_left_path.to_coord_map).to eq(expected_coords)
    end
  end

  describe 'multiple directions' do
    it 'returns coord map with 7 coords' do
      paths = described_class.new(start_coord, default_board).downwards.rightwards

      expected_coords = CoordMap.from_2d_array([[4, 4], [5, 4], [6, 4], [3, 5], [3, 6], [3, 7]])
      expect(paths.to_coord_map).to eq(expected_coords)
    end
  end
end
