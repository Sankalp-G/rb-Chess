require_relative '../../lib/libraries'

describe Knight do
  describe '#valid_move_map' do
    subject(:knight) { described_class.new('blank') }

    let(:board) { Board.new }

    context 'when knight is free to move' do
      let(:start_coord) { CoordPair.new(4, 4) }
      let(:expected_dest) { CoordMap.from_2d_array([[5, 6], [3, 6], [6, 5], [6, 3], [5, 2], [3, 2], [2, 5], [2, 3]]) }
      let(:board) { Board.new_blank_board }

      it 'returns move map with 8 moves' do
        board.place_object_at_coord(knight, start_coord)
        knight_moves = board.moves_for_coord(start_coord)
        expect(knight_moves.dest_coord_map).to eq(expected_dest)
      end
    end

    context 'when knight is in the default knight position' do
      let(:start_coord) { CoordPair.new(0, 1) }
      let(:expected_dest) { CoordMap.from_2d_array([[2, 2], [2, 0]]) }

      it 'returns move map with 2 moves' do
        knight_moves = board.moves_for_coord(start_coord)
        expect(knight_moves.dest_coord_map).to eq(expected_dest)
      end
    end
  end
end
