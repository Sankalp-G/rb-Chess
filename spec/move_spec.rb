require_relative '../lib/libraries'

describe Move do
  describe 'initialize' do
    context 'when coord arguments are not coord pairs' do
      it 'raises an error' do
        start_coord = 'mayonnaise'
        destination_coord = CoordPair.new(3, 2)

        expect { described_class.new(start_coord, destination_coord) }.to raise_error('coord arguments must be coord pair')
      end
    end
  end

  describe 'in_bounds?' do
    context 'when both coord pairs are in bounds' do
      it 'returns true' do
        start_coord = instance_double(CoordPair, { in_bounds?: true, is_a?: true })
        destination_coord = instance_double(CoordPair, { in_bounds?: true, is_a?: true })
        move = described_class.new(start_coord, destination_coord)
        expect(move.in_bounds?).to be(true)
      end
    end

    context 'when any coord pair is out of bounds' do
      it 'returns true' do
        start_coord = instance_double(CoordPair, { in_bounds?: false, is_a?: true })
        destination_coord = instance_double(CoordPair, { in_bounds?: true, is_a?: true })
        move = described_class.new(start_coord, destination_coord)
        expect(move.in_bounds?).to be(false)
      end
    end
  end

  describe '#targeting_friendly?' do
    let(:start_coord) { instance_double(CoordPair, is_a?: true) }
    let(:destination_coord) { instance_double(CoordPair, is_a?: true) }
    let(:board) { instance_double(Board) }

    context 'when target is an ally' do
      let(:start_piece) { instance_double(Piece, color: :white) }
      let(:target_piece) { instance_double(Piece, color: :white) }

      it 'returns true' do
        allow(board).to receive(:piece_at_coord).and_return(start_piece, target_piece)
        move = described_class.new(start_coord, destination_coord)
        expect(move.targeting_friendly?(board)).to be(true)
      end
    end

    context 'when target is not an ally' do
      let(:start_piece) { instance_double(Piece, color: :white) }
      let(:target_piece) { instance_double(Piece, color: :black) }

      it 'returns false' do
        allow(board).to receive(:piece_at_coord).and_return(start_piece, target_piece)
        move = described_class.new(start_coord, destination_coord)
        expect(move.targeting_friendly?(board)).to be(false)
      end
    end
  end

  describe '#==' do
    context 'when moves are equal' do
      it 'returns true' do
        move1 = described_class.new(CoordPair.new(3, 4), CoordPair.new(5, 1))
        move2 = described_class.new(CoordPair.new(3, 4), CoordPair.new(5, 1))
        expect(move1 == move2).to be(true)
      end
    end

    context 'when moves are not equal' do
      it 'returns false' do
        move1 = described_class.new(CoordPair.new(3, 4), CoordPair.new(2, -1))
        move2 = described_class.new(CoordPair.new(3, 4), CoordPair.new(5, 1))
        expect(move1 == move2).to be(false)
      end
    end
  end

  describe '#execute_on_board' do
    let(:execute_board) { Board.new }
    let(:start_coord) { CoordPair.new(6, 3) }
    let(:dest_coord) { CoordPair.new(4, 3) }

    before do
      move = described_class.new(start_coord, dest_coord)
      move.execute_on_board(execute_board)
    end

    it 'clears out start tile' do
      expect(execute_board.piece_at_coord(start_coord)).to be_an(Unoccupied)
    end

    it 'moves piece to destination' do
      expect(execute_board.piece_at_coord(dest_coord)).to be_a(Pawn)
    end
  end

  describe '#endangers_king' do
    let(:danger_board) { Board.new_blank_board }

    before do
      danger_board.place_object_at_coord(King.new(:white), CoordPair.new(3, 1))
      danger_board.place_object_at_coord(Rook.new(:white), CoordPair.new(3, 2))
      danger_board.place_object_at_coord(Rook.new(:black), CoordPair.new(3, 6))
      danger_board.place_object_at_coord(King.new(:black), CoordPair.new(3, 7))
    end

    it 'returns true if own king is in danger after move' do
      dangerous_move = described_class.new(CoordPair.new(3, 2), CoordPair.new(5, 2))
      expect(dangerous_move.endangers_king?(danger_board)).to be(true)
    end

    it 'returns false if own king is not in danger after move' do
      safe_move = described_class.new(CoordPair.new(3, 2), CoordPair.new(3, 4))
      expect(safe_move.endangers_king?(danger_board)).to be(false)
    end

    it 'returns false if opponent king is endangered' do
      move = described_class.new(CoordPair.new(3, 2), CoordPair.new(3, 6))
      expect(move.endangers_king?(danger_board)).to be(false)
    end
  end

  describe 'secondary move' do
    let(:secondary_board) { Board.new }
    let(:main_move) { described_class.new(CoordPair.new(6, 3), CoordPair.new(4, 3)) }
    let(:another_move) { described_class.new(CoordPair.new(6, 4), CoordPair.new(4, 4)) }

    before do
      main_move.secondary_move = another_move
    end

    context 'when main move is executed' do
      before do
        main_move.execute_on_board(secondary_board)
      end

      it 'plays main move' do
        expect(secondary_board.piece_at_coord(CoordPair.new(4, 3))).to be_a(Pawn)
      end

      it 'plays secondary move as well' do
        expect(secondary_board.piece_at_coord(CoordPair.new(4, 4))).to be_a(Pawn)
      end
    end
  end
end
