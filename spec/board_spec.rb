require_relative '../lib/libraries'

describe Board do
  describe '#piece_at_coord' do
    subject(:piece_board) { described_class.new }

    context 'when coord pair is in board bounds' do
      it 'returns the piece at the coord' do
        coord = CoordPair.new(0, 5)
        expect(piece_board.piece_at_coord(coord)).to be_a(Bishop)
      end
    end

    context 'when x coord is out of bounds' do
      it 'returns nil' do
        coord = CoordPair.new(10, 5)
        expect(piece_board.piece_at_coord(coord)).to be_nil
      end
    end

    context 'when y coord is out of bounds' do
      it 'returns nil' do
        coord = CoordPair.new(1, 55)
        expect(piece_board.piece_at_coord(coord)).to be_nil
      end
    end

    context 'when any coord is negative' do
      it 'returns nil' do
        coord = CoordPair.new(6, -5)
        expect(piece_board.piece_at_coord(coord)).to be_nil
      end
    end
  end
end
