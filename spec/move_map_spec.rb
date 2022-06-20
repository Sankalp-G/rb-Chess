require_relative '../lib/libraries'

describe MoveMap do
  describe '#==' do
    let(:start_coord) { CoordPair.new(3, 2) }

    context 'when move maps are equal' do
      it 'returns true' do
        destination_coord_map = CoordMap.from_2d_array([[2, 3], [4, 1], [2, -2]])
        map1 = described_class.new(start_coord, destination_coord_map)
        map2 = described_class.new(start_coord, destination_coord_map)

        expect(map1 == map2).to be(true)
      end
    end

    context 'when move maps are not equal' do
      it 'returns false' do
        destination_coord_map1 = CoordMap.from_2d_array([[2, 3], [4, 1], [2, -2]])
        destination_coord_map2 = CoordMap.from_2d_array([[2, 3], [4, 1], [2, -2], [4, 2]])
        map1 = described_class.new(start_coord, destination_coord_map1)
        map2 = described_class.new(start_coord, destination_coord_map2)

        expect(map1 == map2).to be(false)
      end
    end
  end
end
