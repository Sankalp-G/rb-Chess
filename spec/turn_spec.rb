require_relative '../lib/libraries'

describe Turn do
  subject(:turn_obj) { described_class.new(board, :white) }

  let(:board) { Board.new }
  let(:board_display) { instance_double(BoardDisplay, prints: true, highlight_move_map: true) }

  before do
    allow(board).to receive(:display).and_return(board_display)
    allow(turn_obj).to receive(:puts)
    allow(turn_obj).to receive(:print)
    allow(turn_obj).to receive(:clear_terminal)
  end

  describe '#play' do
    context 'when all inputs are correctly given' do
      before do
        start_coord = 'b2'
        dest_coord  = 'b3'
        allow(turn_obj).to receive(:gets).and_return(start_coord, dest_coord)
      end

      it 'plays out a turn for one player and executes move on board' do
        # pawn moved from b2 to b3
        turn_obj.play
        expect(board.piece_at_coord(CoordPair.from_algebraic_notation('b3'))).to be_a(Pawn)
      end
    end

    context 'when input is invalid then valid' do
      before do
        invalid_input = 'h'
        valid_start_coord = 'b2'
        valid_dest_coord = 'b3'
        allow(turn_obj).to receive(:gets).and_return(invalid_input, valid_start_coord, valid_dest_coord)
      end

      it 'give invalid input prompt and tries again' do
        turn_obj.play
        expect(turn_obj).to have_received(:puts).with("\nInvalid Input.\nUse chess notation eg: c2\n")
      end
    end

    context 'when x or exit command is used' do
      it 'exits the whole program' do
        allow(turn_obj).to receive(:gets).and_return('x')
        expect { turn_obj.play }.to raise_error(SystemExit)
      end
    end

    context 'when b or back command is used' do
      before do
        turn_obj.instance_variable_set('@state', :coord_selected)
        turn_obj.instance_variable_set('@selected_coord', CoordPair.from_algebraic_notation('b2'))
        back_command = 'b'
        start_coord = 'b2'
        dest_coord = 'b3'
        allow(turn_obj).to receive(:gets).and_return(back_command, start_coord, dest_coord)
        allow(turn_obj).to receive(:display_game_screen)
      end

      it 'goes back to initial turn state' do
        turn_obj.play
        expect(turn_obj).to have_received(:display_game_screen).exactly(3).times
      end
    end

    context 'when selected piece has no valid moves' do
      before do
        invalid_start_coord = 'a1'
        valid_start_coord = 'b2'
        dest_coord = 'b3'
        allow(turn_obj).to receive(:gets).and_return(invalid_start_coord, valid_start_coord, dest_coord)
      end

      it 'outputs error prompt and retries' do
        turn_obj.play
        expect(turn_obj).to have_received(:puts).with("\nSelected tile/piece has no valid moves\n")
      end
    end

    context 'when destination coord is invalid' do
      before do
        start_coord = 'b2'
        invalid_dest_coord = 'b6'
        valid_dest_coord = 'b4'
        allow(turn_obj).to receive(:gets).and_return(start_coord, invalid_dest_coord, valid_dest_coord)
      end

      it 'outputs error prompt and retries' do
        turn_obj.play
        expect(turn_obj).to have_received(:puts).with("\nInvalid Destination Coord, Try Again\n")
      end
    end

    context 'when player selects a piece that is not his own color' do
      before do
        invalid_start_coord = 'b7'
        valid_start_coord = 'b2'
        dest_coord = 'b3'
        allow(turn_obj).to receive(:gets).and_return(invalid_start_coord, valid_start_coord, dest_coord)
      end

      it 'outputs error prompt and retries' do
        turn_obj.play
        expect(turn_obj).to have_received(:puts).with("\nYou have to select a piece of your own color.\n")
      end
    end

    context 'when player selects an unoccupied tile' do
      before do
        invalid_start_coord = 'b4'
        valid_start_coord = 'b2'
        dest_coord = 'b3'
        allow(turn_obj).to receive(:gets).and_return(invalid_start_coord, valid_start_coord, dest_coord)
      end

      it 'outputs error prompt and retries' do
        turn_obj.play
        expect(turn_obj).to have_received(:puts).with("\nYou have to select a piece of your own color.\n")
      end
    end
  end
end
