require_relative '../lib/libraries'

describe CoordPair do
  describe '#initialize' do
    context 'with valid x and y coord arguments' do
      it 'creates a new coord object from both coords' do
        new_coord = described_class.new(2, -7)
        expect(new_coord).to have_attributes(x: 2, y: -7)
      end
    end
  end

  describe '#from_array' do
    it 'creates a new coord object from a array' do
      new_coord = described_class.from_array([1, 5])
      expect(new_coord).to have_attributes(x: 1, y: 5)
    end
  end

  describe '#from_algebraic_notation' do
    it 'creates a new coord object from chess algebraic notation' do
      new_coord = described_class.from_algebraic_notation('e5')
      expect(new_coord).to have_attributes(x: 3, y: 4)
    end
  end

  describe '#to_array' do
    subject(:arr_coord) { described_class.new(3, 4) }

    it 'returns an array of the x and y coordinates' do
      expect(arr_coord.to_array).to eql([3, 4])
    end
  end

  describe '#+' do
    context 'when adding positive coords' do
      let(:operand_coord1) { described_class.new(2, 5) }
      let(:operand_coord2) { described_class.new(3, 1) }

      it 'returns a coord object which is an addition of given coords' do
        result_coord = operand_coord1 + operand_coord2
        expect(result_coord).to have_attributes(x: 5, y: 6)
      end
    end

    context 'when adding negative and positive coords' do
      let(:operand_coord1) { described_class.new(-12, 5) }
      let(:operand_coord2) { described_class.new(33, -11) }

      it 'returns a coord object which is an addition of given coords' do
        result_coord = operand_coord1 + operand_coord2
        expect(result_coord).to have_attributes(x: 21, y: -6)
      end
    end
  end

  describe '#==' do
    context 'when coord x and y are both equal' do
      it 'returns true' do
        coord1 = described_class.new(1, 6)
        coord2 = described_class.new(1, 6)
        expect(coord1 == coord2).to be(true)
      end
    end

    context 'when only one coord is different' do
      it 'returns false when x is different' do
        coord1 = described_class.new(15, 36)
        coord2 = described_class.new(12, 36)
        expect(coord1 == coord2).to be(false)
      end

      it 'returns false when y is different' do
        coord1 = described_class.new(12, 5)
        coord2 = described_class.new(12, 36)
        expect(coord1 == coord2).to be(false)
      end
    end

    context 'when both coords are different' do
      it 'returns false' do
        coord1 = described_class.new(32, 5)
        coord2 = described_class.new(-11, 36)
        expect(coord1 == coord2).to be(false)
      end
    end
  end

  describe '#in_bounds?' do
    context 'when pair is in bounds' do
      it 'returns true' do
        pair = described_class.new(2, 3)
        expect(pair.in_bounds?).to be(true)
      end
    end

    context 'when x is out of bounds' do
      it 'returns false' do
        pair = described_class.new(8, 3)
        expect(pair.in_bounds?).to be(false)
      end
    end

    context 'when y is out of bounds' do
      it 'returns false' do
        pair = described_class.new(4, -1)
        expect(pair.in_bounds?).to be(false)
      end
    end

    context 'when both coords are out of bounds' do
      it 'returns false' do
        pair = described_class.new(19, -12)
        expect(pair.in_bounds?).to be(false)
      end
    end
  end

  describe '#offset_by' do
    subject(:offset_pair) { described_class.new(4, 1) }

    it 'offsets coord by given values' do
      result = offset_pair.offset_by(3, -5)
      expect(result).to have_attributes(x: 7, y: -4)
    end
  end
end
