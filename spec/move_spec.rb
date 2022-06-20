require_relative '../lib/libraries'

describe Move do
  describe 'initialize' do
    context 'when coord arguments are not coord pairs' do
      it 'raises an error' do
        start_coord = 'mayonnaise'
        destination_coord = CoordPair.new(3, 2)

        expect { described_class.new(start_coord, destination_coord) }.to raise_error('coord arguments must be coord pair')
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

  describe '#targeting_friendly?' do
    let(:start_coord) { instance_double(CoordPair, is_a?: true) }
    let(:destination_coord) { instance_double(CoordPair, is_a?: true) }
    let(:board) { instance_double(Board) }

    context 'when target is an ally' do
      let(:start_piece) { instance_double(Piece, color: 'white') }
      let(:target_piece) { instance_double(Piece, color: 'white') }

      it 'returns true' do
        allow(board).to receive(:piece_at_coord).and_return(start_piece, target_piece)
        move = described_class.new(start_coord, destination_coord)
        expect(move.targeting_friendly?(board)).to be(true)
      end
    end

    context 'when target is not an ally' do
      let(:start_piece) { instance_double(Piece, color: 'white') }
      let(:target_piece) { instance_double(Piece, color: 'black') }

      it 'returns false' do
        allow(board).to receive(:piece_at_coord).and_return(start_piece, target_piece)
        move = described_class.new(start_coord, destination_coord)
        expect(move.targeting_friendly?(board)).to be(false)
      end
    end
  end

  describe '#==' do
    context 'when moves are equal' do
      it 'returns true' do
        move1 = described_class.new(CoordPair.new(3, 4), CoordPair.new(5, 1))
        move2 = described_class.new(CoordPair.new(3, 4), CoordPair.new(5, 1))
        expect(move1 == move2).to be(true)
      end
    end

    context 'when moves are not equal' do
      it 'returns false' do
        move1 = described_class.new(CoordPair.new(3, 4), CoordPair.new(2, -1))
        move2 = described_class.new(CoordPair.new(3, 4), CoordPair.new(5, 1))
        expect(move1 == move2).to be(false)
      end
    end
  end
end
