require_relative '../lib/libraries'

describe History do
  subject(:history) { described_class.new }

  let(:board) { Board.new }

  describe '#save_board' do
    before do
      history.save_board(board)
      board.place_object_at_coord(Pawn.new('white'), CoordPair.new(4, 4))
      history.save_board(board)
    end

    it 'saves a unique copy of given chess board' do
      history_arr = history.instance_variable_get(:@history_arr)
      expect(history_arr[0]).not_to eql(history_arr[1])
    end
  end

  describe '#piece_moved?' do
    context 'when piece has not been moved on the board' do
      before do
        history.save_board(board)
        history.save_board(board)
        history.save_board(board)
      end

      it 'returns false' do
        piece = board.piece_at_coord(CoordPair.new(1, 5))
        expect(history.piece_moved?(piece)).to be(false)
      end
    end

    context 'when piece has moved on the board' do
      let(:piece) { board.piece_at_coord(CoordPair.new(6, 2)) }

      before do
        history.save_board(board)
        # manually move a pawn
        board.place_object_at_coord(piece, CoordPair.new(4, 2))
        board.place_object_at_coord(Unoccupied.new, CoordPair.new(6, 2))
        history.save_board(board)
        history.save_board(board)
      end

      it 'returns true' do
        expect(history.piece_moved?(piece)).to be(true)
      end
    end
  end
end
