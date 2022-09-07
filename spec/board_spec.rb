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

  describe '#find_coord_of_piece' do
    context 'when given piece exists' do
      let(:target_coord) { CoordPair.new(1, 3) }
      let(:board) { described_class.new }

      it 'returns coordinates of given piece' do
        piece = board.piece_at_coord(target_coord)
        result_coord = board.find_coord_of_piece(piece)
        expect(result_coord).to eq(target_coord)
      end
    end

    context 'when given piece does not exit' do
      let(:board) { described_class.new }

      it 'returns nil' do
        piece = Knight.new('black')
        result = board.find_coord_of_piece(piece)
        expect(result).to be_nil
      end
    end
  end

  describe '#coord_is_targeted?' do
    subject(:target_board) { described_class.new }

    context 'when coord is being targeted' do
      it 'returns true when coord is unoccupied' do
        coord = CoordPair.new(2, 5)
        expect(target_board.coord_is_targeted?(coord)).to be(true)
      end

      it 'returns true when coord is occupied' do
        coord = CoordPair.new(5, 2)
        target_board.place_object_at_coord(Bishop.new('black'), coord)
        expect(target_board.coord_is_targeted?(coord)).to be(true)
      end
    end

    context 'when coord is not targeted' do
      it 'returns false' do
        coord = CoordPair.new(4, 4)
        target_board.place_object_at_coord(Knight.new('black'), coord)
        expect(target_board.coord_is_targeted?(coord)).to be(false)
      end
    end
  end

  describe '#check?' do
    subject(:check_board) { described_class.new }

    context 'when kings are not targeted' do
      it 'returns nil' do
        expect(check_board.check).to be_nil
      end
    end

    context 'when black king is targeted' do
      before do
        check_board.place_object_at_coord(Rook.new('white'), CoordPair.new(1, 4))
      end

      it 'returns "black"' do
        expect(check_board.check).to eql('black')
      end
    end

    context 'when white king is targeted' do
      before do
        check_board.place_object_at_coord(Bishop.new('black'), CoordPair.new(6, 5))
      end

      it 'returns "white"' do
        expect(check_board.check).to eql('white')
      end
    end
  end
end
