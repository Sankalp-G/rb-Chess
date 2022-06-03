require_relative '../lib/libraries'

describe CoordMap do
  describe '#initialize' do
    context 'with valid coord pair array' do
      it 'creates an object' do
        coord_pair_array = [CoordPair.new(1, 2), CoordPair.new(-21, 22), CoordPair.new(1, 54)]
        new_object = described_class.new(coord_pair_array)
        expect(new_object).to be_instance_of(described_class)
      end
    end

    context 'when argument is not an array' do
      it 'raises an error' do
        invalid_arg = 'apple pie'
        expect { described_class.new(invalid_arg) }
          .to raise_error('argument must be a an array of coord pairs')
      end
    end

    context 'when array elements aren\'t coord pairs' do
      it 'raises an error' do
        invalid_array = ['a', [1, 2], 23, 55]
        expect { described_class.new(invalid_array) }
          .to raise_error('array must only contain coord pair objects')
      end
    end
  end

  describe '#from_2d_array' do
    context 'with valid 2d array' do
      it 'creates an object' do
        valid_arg = [[1, 2], [33, 12], [-2, 233], [12, -33]]
        new_object = described_class.from_2d_array(valid_arg)
        expect(new_object).to be_instance_of(described_class)
      end
    end

    context 'when argument is not an array' do
      it 'raises an error' do
        invalid_arg = 'pineapple_pie'
        expect { described_class.from_2d_array(invalid_arg) }
          .to raise_error('argument must be a an array of coord sub arrays')
      end
    end
  end

  describe '#append' do
    subject(:append_map) { described_class.from_2d_array([[1, 2], [3, 4], [4, 5]]) }

    context 'with valid coord pair' do
      it 'adds another coord pair to coord map' do
        expect { append_map.append(CoordPair.new(3, 2)) }.to change(append_map, :length).by(1)
      end
    end

    context 'when argument is not a coord pair' do
      it 'raises an error' do
        bad_arg = 'tomato_sauce'
        expect { append_map.append(bad_arg) }.to raise_error('can only append coord pair object')
      end
    end
  end

  describe '#all_add' do
    subject(:add_map) { described_class.from_2d_array([[12, 22], [33, 54], [2, -8]]) }

    it 'adds argument coord to each pair in map' do
      add_map.all_add(CoordPair.new(1, 2))

      condition = add_map.coord_at_index(0).x == 13 && add_map.coord_at_index(0).y == 24 &&
                  add_map.coord_at_index(1).x == 34 && add_map.coord_at_index(1).y == 56 &&
                  add_map.coord_at_index(2).x == 3  && add_map.coord_at_index(2).y == -6

      expect(condition).to be(true)
    end
  end

  describe '#==' do
    context 'when both maps are equal' do
      it 'returns false' do
        map1 = described_class.from_2d_array([[1, 2], [3, 5]])
        map2 = described_class.from_2d_array([[1, 2], [3, 5]])

        expect(map1 == map2).to be(true)
      end
    end

    context 'when one map has more coords than the other' do
      it 'returns false' do
        map1 = described_class.from_2d_array([[4, 5], [123, 23]])
        map2 = described_class.from_2d_array([[4, 5], [123, 23], [5, 3]])

        expect(map1 == map2).to be(false)
      end
    end

    context 'when same number of coords but coords values are different' do
      it 'returns false' do
        map1 = described_class.from_2d_array([[2, 34], [21, 33], [23, 4]])
        map2 = described_class.from_2d_array([[23, 12], [12, 3], [32, 21]])

        expect(map1 == map2).to be(false)
      end
    end
  end
end
