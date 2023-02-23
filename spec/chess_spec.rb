require_relative '../lib/libraries'

describe Chess do
  subject(:chess_game) { described_class.new }

  describe '#main_menu' do
    before do
      allow(chess_game).to receive(:puts)
      allow(chess_game).to receive(:clear_terminal)
      allow(chess_game).to receive(:new_game)
    end

    context 'when valid menu input is given' do
      before do
        valid_menu_option = '1'
        allow(chess_game).to receive(:gets).and_return(valid_menu_option)
      end

      it 'executes menu option' do
        expect(chess_game).to receive(:new_game).once
        chess_game.main_menu
      end
    end

    context 'when invalid menu input is given' do
      before do
        invalid_inputs = %w[155 32]
        valid_input = '1'

        allow(chess_game).to receive(:gets).and_return(*invalid_inputs, valid_input)
      end

      it 'retries until valid input is given' do
        expect(chess_game).to receive(:gets).exactly(3).times
        chess_game.main_menu
      end
    end
  end

  describe '#checkmate?' do
    before do
      chess_game.new_game
    end

    it 'returns false when there is no checkmate' do
      expect(chess_game.checkmate?).to be(false)
    end

    it 'returns false when there is a check but no checkmate' do
      check_board = Board.new
      check_board.place_object_at_coord(Queen.new(:black), CoordPair.new(6, 4))
      chess_game.instance_variable_set(:@board, check_board)
      expect(chess_game.checkmate?).to be(false)
    end

    context 'when there is a checkmate' do
      let(:checkmate_board) { Board.new }

      before do
        checkmate_board.place_object_at_coord(Queen.new(:black), CoordPair.new(6, 4))
        checkmate_board.place_object_at_coord(Queen.new(:black), CoordPair.new(7, 5))
        chess_game.instance_variable_set(:@board, checkmate_board)
      end

      it 'returns true' do
        expect(chess_game.checkmate?).to be(true)
      end
    end
  end

  describe '#stalemate' do
    before do
      chess_game.new_game
    end

    context 'when there is no stalemate' do
      it 'returns false' do
        expect(chess_game.stalemate?).to be(false)
      end
    end

    context 'when there is a stalemate' do
      let(:stale_board) { Board.new_blank_board }

      before do
        stale_board.place_object_at_coord(King.new(:black), CoordPair.new(0, 0))
        stale_board.place_object_at_coord(Queen.new(:black), CoordPair.new(6, 5))
        stale_board.place_object_at_coord(King.new(:white), CoordPair.new(7, 7))
        chess_game.instance_variable_set(:@board, stale_board)
      end

      it 'returns true' do
        expect(chess_game.stalemate?).to be(true)
      end
    end
  end
end
