require_relative '../../lib/libraries'

describe Knight do
  describe '#get_valid_move_map' do
    let(:board) { Board.new }

    context 'when knight is free to move' do
      let(:start_coord) { CoordPair.new(4, 4) }
      let(:blank_tiles) { Array.new(8) { Array.new(8) { Unoccupied.new } } }
      let(:expected_dest) { CoordMap.from_2d_array([[5, 6], [3, 6], [6, 5], [6, 3], [5, 2], [3, 2], [2, 5], [2, 3]]) }
      let(:expected_moves) { MoveMap.new(start_coord, expected_dest) }

      before do
        board.instance_variable_set(:@board, blank_tiles)
        knight = described_class.new('black')
        board.place_object_at_coord(knight, start_coord)
      end

      it 'returns move map with 8 moves' do
        knight_moves = board.moves_for_coord(start_coord)
        expect(knight_moves).to eq(expected_moves)
      end
    end

    context 'when knight is in the default knight position' do
      let(:start_coord) { CoordPair.new(0, 1) }
      let(:expected_dest) { CoordMap.from_2d_array([[2, 2], [2, 0]]) }
      let(:expected_moves) { MoveMap.new(start_coord, expected_dest) }

      it 'returns move map with 2 moves' do
        knight_moves = board.moves_for_coord(start_coord)
        expect(knight_moves).to eq(expected_moves)
      end
    end
  end
end
