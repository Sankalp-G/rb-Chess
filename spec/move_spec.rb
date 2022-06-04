require_relative '../lib/libraries'

describe Move do
  describe 'initialize' do
    context 'when coord arguments are not coord pairs' do
      it 'raises an error' do
        start_coord = 'mayonnaise'
        destination_coord = CoordPair.new(3, 2)

        expect { described_class.new(start_coord, destination_coord) }.to raise_error('arguments must be coord pairs')
      end
    end
  end

  describe 'in_bounds?' do
    context 'when both coord pairs are in bounds' do
      it 'returns true' do
        start_coord = instance_double(CoordPair, { in_bounds?: true, is_a?: true })
        destination_coord = instance_double(CoordPair, { in_bounds?: true, is_a?: true })
        move = described_class.new(start_coord, destination_coord)
        expect(move.in_bounds?).to be(true)
      end
    end

    context 'when any coord pair is out of bounds' do
      it 'returns true' do
        start_coord = instance_double(CoordPair, { in_bounds?: false, is_a?: true })
        destination_coord = instance_double(CoordPair, { in_bounds?: true, is_a?: true })
        move = described_class.new(start_coord, destination_coord)
        expect(move.in_bounds?).to be(false)
      end
    end
  end
end
