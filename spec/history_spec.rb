require_relative '../lib/libraries'

describe History do
  subject(:history) { described_class.new }

  describe '#save_board' do
    before do
      board = Board.new
      history.save_board(board)
      board.place_object_at_coord(Pawn.new('white'), CoordPair.new(4, 4))
      history.save_board(board)
    end

    it 'saves a unique copy of given chess board' do
      history_arr = history.instance_variable_get(:@history_arr)
      expect(history_arr[0]).not_to eql(history_arr[1])
    end
  end
end
