require_relative '../../lib/libraries'

describe Pawn do
  let(:board) { Board.new }
  let(:unmoved_history) { double('unmoved_history', piece_moved?: false) }
  let(:moved_history) { double('moved_history', piece_moved?: true) }

  describe '#valid_move_map' do
    context 'when pawn is at the initial position' do
      before do
        allow(board).to receive(:history).and_return(unmoved_history)
      end

      it 'returns correct move map for black' do
        pawn_moves = board.moves_for_coord(CoordPair.new(1, 3))
        dest_coords = pawn_moves.dest_coord_map

        expected_coords = CoordMap.from_2d_array([[2, 3], [3, 3]])
        expect(dest_coords).to eq(expected_coords)
      end

      it 'returns correct move map for white' do
        pawn_moves = board.moves_for_coord(CoordPair.new(6, 4))
        dest_coords = pawn_moves.dest_coord_map

        expected_coords = CoordMap.from_2d_array([[5, 4], [4, 4]])
        expect(dest_coords).to eq(expected_coords)
      end
    end

    context 'when pawn has already moved before' do
      let(:pawn_coord) { CoordPair.new(5, 4) }
      let(:pawn_dest_coords) { board.moves_for_coord(pawn_coord).dest_coord_map }

      before do
        allow(board).to receive(:history).and_return(moved_history)
        board.place_object_at_coord(described_class.new('white'), pawn_coord)
      end

      it 'returns no moves when enemy is front' do
        board.place_object_at_coord(Knight.new('black'), CoordPair.new(4, 4))

        expected_coords = CoordMap.from_2d_array([])
        expect(pawn_dest_coords).to eq(expected_coords)
      end

      it 'returns one move when no enemy is in range' do
        expected_coords = CoordMap.from_2d_array([[4, 4]])
        expect(pawn_dest_coords).to eq(expected_coords)
      end

      it 'returns 2 moves when enemy is on the left' do
        board.place_object_at_coord(Knight.new('black'), CoordPair.new(4, 3))

        expected_coords = CoordMap.from_2d_array([[4, 4], [4, 3]])
        expect(pawn_dest_coords).to eq(expected_coords)
      end

      it 'returns 3 moves when enemies are on both sides' do
        board.place_object_at_coord(Knight.new('black'), CoordPair.new(4, 3))
        board.place_object_at_coord(Knight.new('black'), CoordPair.new(4, 5))

        expected_coords = CoordMap.from_2d_array([[4, 4], [4, 3], [4, 5]])
        expect(pawn_dest_coords).to eq(expected_coords)
      end
    end
  end
end
