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

  describe '#threefold_repetition?' do
    before do
      chess_game.new_game
    end

    context 'when there is no threefold repetition' do
      it 'returns false' do
        expect(chess_game.threefold_repetition?).to be(false)
      end
    end

    context 'when there is threefold repetition' do
      let(:repetition_board) { Board.new }

      before do
        3.times do
          repetition_board.move_piece_from_to(CoordPair.new(0, 1), CoordPair.new(2, 2))
          repetition_board.save_to_history
          repetition_board.move_piece_from_to(CoordPair.new(2, 2), CoordPair.new(0, 1))
          repetition_board.save_to_history
        end

        chess_game.instance_variable_set(:@board, repetition_board)
      end

      it 'returns true' do
        expect(chess_game.threefold_repetition?).to be(true)
      end
    end

    context 'when there is threefold repetition but not in a row' do
      let(:repetition_board) { Board.new }

      before do
        2.times do
          repetition_board.move_piece_from_to(CoordPair.new(0, 1), CoordPair.new(2, 2))
          repetition_board.save_to_history
          repetition_board.move_piece_from_to(CoordPair.new(2, 2), CoordPair.new(0, 1))
          repetition_board.save_to_history
        end

        repetition_board.move_piece_from_to(CoordPair.new(0, 3), CoordPair.new(2, 4))
        repetition_board.save_to_history
        repetition_board.move_piece_from_to(CoordPair.new(0, 1), CoordPair.new(2, 2))
        repetition_board.save_to_history
        repetition_board.move_piece_from_to(CoordPair.new(2, 4), CoordPair.new(0, 3))
        repetition_board.save_to_history

        chess_game.instance_variable_set(:@board, repetition_board)
      end

      it 'returns true' do
        expect(chess_game.threefold_repetition?).to be(true)
      end
    end
  end

  describe '#_50_move_rule?' do
    let(:_50_move_board) { Board.new }

    before do
      chess_game.new_game
    end

    context 'when there is no 50 move rule' do
      it 'returns false' do
        expect(chess_game._50_move_rule?).to be(false)
      end
    end

    context 'when there was a capture 50 moves ago but no pawn moved' do
      before do
        _50_move_board.place_object_at_coord(Unoccupied.new, CoordPair.new(0, 1))

        49.times do
          _50_move_board.save_to_history
        end

        chess_game.instance_variable_set(:@board, _50_move_board)
      end

      it 'returns false' do
        expect(chess_game._50_move_rule?).to be(false)
      end
    end

    context 'when there was a pawn move 50 moves ago but no capture' do
      before do
        _50_move_board.move_piece_from_to(CoordPair.new(6, 2), CoordPair.new(4, 2))

        49.times do
          _50_move_board.save_to_history
        end

        chess_game.instance_variable_set(:@board, _50_move_board)
      end

      it 'returns false' do
        expect(chess_game._50_move_rule?).to be(false)
      end
    end

    context 'when there is 50 move rule' do
      before do
        25.times do
          _50_move_board.move_piece_from_to(CoordPair.new(0, 1), CoordPair.new(2, 2))
          _50_move_board.save_to_history
          _50_move_board.move_piece_from_to(CoordPair.new(2, 2), CoordPair.new(0, 1))
          _50_move_board.save_to_history
        end

        chess_game.instance_variable_set(:@board, _50_move_board)
      end

      it 'returns true' do
        expect(chess_game._50_move_rule?).to be(true)
      end
    end
  end

  describe '#pawn_promotion?' do
    before do
      chess_game.new_game
    end

    context 'when there is no pawn promotion' do
      it 'returns false' do
        expect(chess_game.pawn_promotion?).to be(false)
      end
    end

    context 'when there is a pawn at the topmost or bottomost row' do
      let(:promotion_board) { Board.new }

      before do
        promotion_board.place_object_at_coord(Pawn.new(:white), CoordPair.new(0, 6))
        promotion_board.place_object_at_coord(King.new(:black), CoordPair.new(7, 0))
        chess_game.instance_variable_set(:@board, promotion_board)
      end

      it 'returns true' do
        expect(chess_game.pawn_promotion?).to be(true)
      end
    end
  end
end
