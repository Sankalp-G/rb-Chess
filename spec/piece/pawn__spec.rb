require_relative '../../lib/libraries'

describe Pawn do
  let(:board) { Board.new }
  let(:unmoved_history) { double('unmoved_history', piece_moved?: false) }
  let(:moved_history) { double('moved_history', piece_moved?: true) }

  describe '#valid_move_map' do
    context 'when pawn is at the initial position' do
      before do
        allow(board).to receive(:history).and_return(unmoved_history)
      end

      it 'returns correct move map for black' do
        pawn_moves = board.moves_for_coord(CoordPair.new(1, 3))
        dest_coords = pawn_moves.dest_coord_map

        expected_coords = CoordMap.from_2d_array([[2, 3], [3, 3]])
        expect(dest_coords).to eq(expected_coords)
      end

      it 'returns correct move map for white' do
        pawn_moves = board.moves_for_coord(CoordPair.new(6, 4))
        dest_coords = pawn_moves.dest_coord_map

        expected_coords = CoordMap.from_2d_array([[5, 4], [4, 4]])
        expect(dest_coords).to eq(expected_coords)
      end
    end

    context 'when pawn has already moved before' do
      let(:pawn_coord) { CoordPair.new(5, 4) }
      let(:pawn_dest_coords) { board.moves_for_coord(pawn_coord).dest_coord_map }

      before do
        allow(board).to receive(:history).and_return(moved_history)
        board.place_object_at_coord(described_class.new(:white), pawn_coord)
      end

      it 'returns no moves when enemy is front' do
        board.place_object_at_coord(Knight.new(:black), CoordPair.new(4, 4))

        expected_coords = CoordMap.from_2d_array([])
        expect(pawn_dest_coords).to eq(expected_coords)
      end

      it 'returns one move when no enemy is in range' do
        expected_coords = CoordMap.from_2d_array([[4, 4]])
        expect(pawn_dest_coords).to eq(expected_coords)
      end

      it 'returns 2 moves when enemy is on the left' do
        board.place_object_at_coord(Knight.new(:black), CoordPair.new(4, 3))

        expected_coords = CoordMap.from_2d_array([[4, 4], [4, 3]])
        expect(pawn_dest_coords).to eq(expected_coords)
      end

      it 'returns 3 moves when enemies are on both sides' do
        board.place_object_at_coord(Knight.new(:black), CoordPair.new(4, 3))
        board.place_object_at_coord(Knight.new(:black), CoordPair.new(4, 5))

        expected_coords = CoordMap.from_2d_array([[4, 4], [4, 3], [4, 5]])
        expect(pawn_dest_coords).to eq(expected_coords)
      end
    end
  end

  describe '#can_en_passant_left?' do
    let(:pawn_coord) { CoordPair.new(3, 4) }
    let(:main_pawn) { board.piece_at_coord(pawn_coord) }

    before do
      board.place_object_at_coord(described_class.new(:white), pawn_coord)
    end

    context 'when en passant is not possible' do
      it 'returns false' do
        expect(main_pawn.can_en_passant_left?(pawn_coord, board)).to be(false)
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
        expect(main_pawn.can_en_passant_left?(pawn_coord, board)).to be(false)
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
        expect(main_pawn.can_en_passant_left?(pawn_coord, board)).to be(false)
      end
    end

    context 'when en passant is possible' do
      before do
        # move left pawn up
        board.move_piece_from_to(CoordPair.new(1, 3), CoordPair.new(3, 3))
        board.save_to_history
      end

      it 'returns true' do
        expect(main_pawn.can_en_passant_left?(pawn_coord, board)).to be(true)
      end
    end
  end

  describe '#can_en_passant_right?' do
    let(:pawn_coord) { CoordPair.new(4, 5) }
    let(:main_pawn) { board.piece_at_coord(pawn_coord) }

    before do
      board.place_object_at_coord(described_class.new(:black), pawn_coord)
    end

    context 'when en passant is not possible' do
      it 'returns false' do
        expect(main_pawn.can_en_passant_right?(pawn_coord, board)).to be(false)
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
        expect(main_pawn.can_en_passant_right?(pawn_coord, board)).to be(false)
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
        expect(main_pawn.can_en_passant_right?(pawn_coord, board)).to be(false)
      end
    end

    context 'when en passant is possible' do
      before do
        # move left pawn up
        board.move_piece_from_to(CoordPair.new(6, 6), CoordPair.new(4, 6))
        board.save_to_history
      end

      it 'returns true' do
        expect(main_pawn.can_en_passant_right?(pawn_coord, board)).to be(true)
      end
    end
  end

  describe '#left_en_passant_move' do
    let(:pawn_coord) { CoordPair.new(4, 3) }
    let(:pawn) { board.piece_at_coord(pawn_coord) }

    before do
      board.place_object_at_coord(described_class.new(:black), pawn_coord)
    end

    it 'has correct destination' do
      move = pawn.left_en_passant_move(pawn_coord)
      expect(move.destination_coord).to eq(CoordPair.new(5, 2))
    end

    it 'has correct deletion coord' do
      move = pawn.left_en_passant_move(pawn_coord)
      expect(move.deletion_coord).to eq(CoordPair.new(4, 2))
    end
  end

  describe '#right_en_passant_move' do
    let(:pawn_coord) { CoordPair.new(3, 5) }
    let(:pawn) { board.piece_at_coord(pawn_coord) }

    before do
      board.place_object_at_coord(described_class.new(:white), pawn_coord)
    end

    it 'has correct destination' do
      move = pawn.right_en_passant_move(pawn_coord)
      expect(move.destination_coord).to eq(CoordPair.new(2, 6))
    end

    it 'has correct deletion coord' do
      move = pawn.right_en_passant_move(pawn_coord)
      expect(move.deletion_coord).to eq(CoordPair.new(3, 6))
    end
  end
end
