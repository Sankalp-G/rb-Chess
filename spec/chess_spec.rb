require_relative '../lib/libraries'

describe Chess do
  subject(:chess_game) { described_class.new }

  describe '#checkmate?' do
    it 'returns false when there is no checkmate' do
      chess_game.new_game
      expect(chess_game.checkmate?).to be(false)
    end

    it 'returns false when there is a check but no checkmate' do
      chess_game.new_game
      check_board = Board.new
      check_board.place_object_at_coord(Queen.new('black'), CoordPair.new(6, 4))
      chess_game.instance_variable_set(:@board, check_board)
      expect(chess_game.checkmate?).to be(false)
    end

    context 'when there is a checkmate' do
      let(:checkmate_board) { Board.new }

      before do
        checkmate_board.place_object_at_coord(Queen.new('black'), CoordPair.new(6, 4))
        checkmate_board.place_object_at_coord(Queen.new('black'), CoordPair.new(7, 5))
        chess_game.new_game
        chess_game.instance_variable_set(:@board, checkmate_board)
      end

      it 'returns true' do
        expect(chess_game.checkmate?).to be(true)
      end
    end
  end

  describe '#stalemate' do
    context 'when there is no stalemate' do
      it 'returns false' do
        chess_game.new_game
        expect(chess_game.stalemate?).to be(false)
      end
    end

    context 'when there is a stalemate' do
      let(:stale_board) { Board.new_blank_board }

      before do
        stale_board.place_object_at_coord(King.new('black'), CoordPair.new(0, 0))
        stale_board.place_object_at_coord(Queen.new('black'), CoordPair.new(6, 5))
        stale_board.place_object_at_coord(King.new('white'), CoordPair.new(7, 7))
        chess_game.new_game
        chess_game.instance_variable_set(:@board, stale_board)
      end

      it 'returns true' do
        expect(chess_game.stalemate?).to be(true)
      end
    end
  end
end
