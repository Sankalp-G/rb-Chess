require_relative '../lib/libraries'

describe Castling do
  describe '#can_castle_left?' do
    let(:castle_board) { Board.new }
    let(:king_coord) { CoordPair.new(7, 4) }

    before do
      # clear path between king and rook
      castle_board.place_object_at_coord(Unoccupied.new, CoordPair.new(7, 1))
      castle_board.place_object_at_coord(Unoccupied.new, CoordPair.new(7, 2))
      castle_board.place_object_at_coord(Unoccupied.new, CoordPair.new(7, 3))
    end

    context 'when all castling conditions are satisfied' do
      it 'returns true' do
        castle_obj = described_class.new(king_coord, castle_board)
        expect(castle_obj.can_castle_left?).to be(true)
      end
    end

    context 'when castling conditions are not satisfied' do
      it 'returns false when path between rook and king is blocked' do
        castle_board.place_object_at_coord(Knight.new(:white), CoordPair.new(7, 2))
        castle_obj = described_class.new(king_coord, castle_board)
        expect(castle_obj.can_castle_left?).to be(false)
      end

      it 'returns false if king is in check' do
        # place rook in front of king
        castle_board.place_object_at_coord(Rook.new(:black), CoordPair.new(6, 4))
        castle_obj = described_class.new(king_coord, castle_board)
        expect(castle_obj.can_castle_left?).to be(false)
      end

      it 'returns false if king path is in check' do
        castle_board.place_object_at_coord(Rook.new(:black), CoordPair.new(6, 2))
        castle_obj = described_class.new(king_coord, castle_board)
        expect(castle_obj.can_castle_left?).to be(false)
      end
    end
  end

  describe '#can_castle_right?' do
    let(:castle_board) { Board.new }
    let(:king_coord) { CoordPair.new(0, 4) }

    before do
      # clear path between king and rook
      castle_board.place_object_at_coord(Unoccupied.new, CoordPair.new(0, 5))
      castle_board.place_object_at_coord(Unoccupied.new, CoordPair.new(0, 6))
      castle_board.place_object_at_coord(Unoccupied.new, CoordPair.new(0, 7))
    end

    context 'when all castling conditions are satisfied' do
      it 'returns true' do
        castle_obj = described_class.new(king_coord, castle_board)
        expect(castle_obj.can_castle_right?).to be(true)
      end
    end

    context 'when castling conditions are not satisfied' do
      it 'returns false when path between rook and king is blocked' do
        castle_board.place_object_at_coord(Knight.new(:black), CoordPair.new(0, 6))
        castle_obj = described_class.new(king_coord, castle_board)
        expect(castle_obj.can_castle_right?).to be(false)
      end

      it 'returns false if king is in check' do
        # place rook in front of king
        castle_board.place_object_at_coord(Rook.new(:white), CoordPair.new(1, 4))
        castle_obj = described_class.new(king_coord, castle_board)
        expect(castle_obj.can_castle_right?).to be(false)
      end

      it 'returns false if king path is in check' do
        castle_board.place_object_at_coord(Rook.new(:white), CoordPair.new(1, 6))
        castle_obj = described_class.new(king_coord, castle_board)
        expect(castle_obj.can_castle_right?).to be(false)
      end
    end
  end
end
