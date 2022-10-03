require_relative '../../lib/libraries'

describe King do
  let(:king_board) { Board.new }

  describe '#valid_move_map' do
    subject(:king) { described_class.new(:white) }

    context 'when king is free to move' do
      let(:king_coord) { CoordPair.new(4, 4) }
      let(:expected_dest) { CoordMap.from_2d_array([[3, 3], [3, 4], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5]]) }

      it 'returns move map with 8 moves' do
        king_board.place_object_at_coord(king, king_coord)
        king_moves = king_board.moves_for_coord(king_coord)
        expect(king_moves.dest_coord_map).to eq(expected_dest)
      end
    end

    context 'when king can only move forward' do
      let(:king_coord) { CoordPair.new(7, 4) }
      let(:expected_dest) { CoordMap.from_2d_array([[6, 4]]) }

      it 'returns move map with 1 moves' do
        king_board.place_object_at_coord(Unoccupied.new, CoordPair.new(6, 4))
        king_moves = king_board.moves_for_coord(king_coord)
        expect(king_moves.dest_coord_map).to eq(expected_dest)
      end
    end
  end

  describe 'castling tests' do
    let(:king_coord) { CoordPair.new(0, 4) }
    let(:king_moves) { king_board.moves_for_coord(king_coord) }

    before do
      # clear path between king and rook
      king_board.place_object_at_coord(Unoccupied.new, CoordPair.new(0, 5))
      king_board.place_object_at_coord(Unoccupied.new, CoordPair.new(0, 6))
    end

    describe '#valid_move_map' do
      it 'returns move map with 2 moves' do
        # two moves one for moving right and one for castling
        expected_dest = CoordMap.from_2d_array([[0, 5], [0, 6]])
        expect(king_moves.dest_coord_map).to eq(expected_dest)
      end
    end

    describe 'executing castling move' do
      let(:castling_move) { king_moves.moves_arr.last }

      before do
        castling_move.execute_on_board(king_board)
      end

      it 'moves the king' do
        expect(king_board.piece_at_coord(CoordPair.new(0, 6))).to be_a(described_class)
      end

      it 'moves the rook' do
        expect(king_board.piece_at_coord(CoordPair.new(0, 5))).to be_a(Rook)
      end
    end
  end
end
