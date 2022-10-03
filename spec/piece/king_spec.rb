require_relative '../../lib/libraries'

describe King do
  describe '#valid_move_map' do
    subject(:king) { described_class.new(:white) }

    let(:king_board) { Board.new }

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
end
