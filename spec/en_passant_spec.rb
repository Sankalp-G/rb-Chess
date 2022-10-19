require_relative '../lib/libraries'

describe EnPassant do
  let(:board) { Board.new }
  let(:en_passant) { described_class.new(pawn_coord, board) }

  describe '#can_en_passant_left?' do
    let(:pawn_coord) { CoordPair.new(3, 4) }
    let(:pawn) { board.piece_at_coord(pawn_coord) }

    before do
      board.place_object_at_coord(Pawn.new(:white), pawn_coord)
    end

    context 'when en passant is not possible' do
      it 'returns false' do
        expect(en_passant.can_en_passant_left?).to be(false)
      end
    end

    context 'when enemy pawn did not move last turn' do
      before do
        # move left pawn two spaces
        board.move_piece_from_to(CoordPair.new(1, 3), CoordPair.new(3, 3))
        board.save_to_history
        board.save_to_history
      end

      it 'returns false' do
        expect(en_passant.can_en_passant_left?).to be(false)
      end
    end

    context 'when enemy pawn did not move two spaces at once' do
      before do
        # move left pawn one place twice
        board.move_piece_from_to(CoordPair.new(1, 3), CoordPair.new(2, 3))
        board.save_to_history
        board.move_piece_from_to(CoordPair.new(2, 3), CoordPair.new(3, 3))
        board.save_to_history
      end

      it 'returns false' do
        expect(en_passant.can_en_passant_left?).to be(false)
      end
    end

    context 'when en passant is possible' do
      before do
        # move left pawn up
        board.move_piece_from_to(CoordPair.new(1, 3), CoordPair.new(3, 3))
        board.save_to_history
      end

      it 'returns true' do
        expect(en_passant.can_en_passant_left?).to be(true)
      end
    end
  end

  describe '#can_en_passant_right?' do
    let(:pawn_coord) { CoordPair.new(4, 5) }
    let(:pawn) { board.piece_at_coord(pawn_coord) }

    before do
      board.place_object_at_coord(Pawn.new(:black), pawn_coord)
    end

    context 'when en passant is not possible' do
      it 'returns false' do
        expect(en_passant.can_en_passant_right?).to be(false)
      end
    end

    context 'when enemy pawn did not move last turn' do
      before do
        # move left pawn two spaces
        board.move_piece_from_to(CoordPair.new(6, 6), CoordPair.new(4, 6))
        board.save_to_history
        board.save_to_history
      end

      it 'returns false' do
        expect(en_passant.can_en_passant_right?).to be(false)
      end
    end

    context 'when enemy pawn did not move two spaces at once' do
      before do
        # move left pawn one place twice
        board.move_piece_from_to(CoordPair.new(6, 6), CoordPair.new(5, 6))
        board.save_to_history
        board.move_piece_from_to(CoordPair.new(5, 6), CoordPair.new(4, 6))
        board.save_to_history
      end

      it 'returns false' do
        expect(en_passant.can_en_passant_right?).to be(false)
      end
    end

    context 'when en passant is possible' do
      before do
        # move left pawn up
        board.move_piece_from_to(CoordPair.new(6, 6), CoordPair.new(4, 6))
        board.save_to_history
      end

      it 'returns true' do
        expect(en_passant.can_en_passant_right?).to be(true)
      end
    end
  end

  describe '#left_en_passant_move' do
    let(:pawn_coord) { CoordPair.new(4, 3) }
    let(:pawn) { board.piece_at_coord(pawn_coord) }

    before do
      board.place_object_at_coord(Pawn.new(:black), pawn_coord)
    end

    it 'has correct destination' do
      move = en_passant.left_en_passant_move
      expect(move.destination_coord).to eq(CoordPair.new(5, 2))
    end

    it 'has correct deletion coord' do
      move = en_passant.left_en_passant_move
      expect(move.deletion_coord).to eq(CoordPair.new(4, 2))
    end
  end

  describe '#right_en_passant_move' do
    let(:pawn_coord) { CoordPair.new(3, 5) }
    let(:pawn) { board.piece_at_coord(pawn_coord) }

    before do
      board.place_object_at_coord(Pawn.new(:white), pawn_coord)
    end

    it 'has correct destination' do
      move = en_passant.right_en_passant_move
      expect(move.destination_coord).to eq(CoordPair.new(2, 6))
    end

    it 'has correct deletion coord' do
      move = en_passant.right_en_passant_move
      expect(move.deletion_coord).to eq(CoordPair.new(3, 6))
    end
  end
end
