require_relative '../lib/libraries'

describe Turn do
  describe '#query_coord_from_player' do
    subject(:coord_turn) { described_class.new(board, :black) }

    let(:board) { Board.new }

    context 'when given valid algebraic notation string' do
      before do
        valid_string = 'c6'
        allow(coord_turn).to receive(:gets).and_return(valid_string)
      end

      it 'returns the corresponding coord' do
        expected_coord = CoordPair.new(2, 2)
        expect(coord_turn.query_coord_from_player).to eq(expected_coord)
      end
    end

    context 'when given invalid then valid strings' do
      before do
        invalid_strings = %w[abcd t3 c9]
        valid_string = 'e3'
        allow(coord_turn).to receive(:gets).and_return(*invalid_strings, valid_string)
        allow(coord_turn).to receive(:puts)
      end

      it 'retries input until valid string is given' do
        expect(coord_turn).to receive(:gets).exactly(4).times
        coord_turn.query_coord_from_player
      end

      it 'returns coord for valid input string' do
        expected_coord = CoordPair.new(5, 4)
        expect(coord_turn.query_coord_from_player).to eq(expected_coord)
      end
    end
  end
end
