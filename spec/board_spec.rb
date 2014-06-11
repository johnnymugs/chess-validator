require 'spec_helper'

describe Board do
  describe "#add" do
    subject { -> { board.add(piece: piece, at: position) } }
    let(:board) { Board.new }
    let(:piece) { Pawn.new }
    let(:position) { "a1" }

    context "with a valid position" do
      it { should change(board.pieces, :count).by(1) }
      it { should change{ board.piece_at(position) }.from(nil).to(piece) }
    end

    context "with a nonsense position" do
      let(:position) { "j9" }
      it { should raise_error }
    end

    context "with a piece on the position" do
      before { board.add(piece: piece, at: position) }
      it { should raise_error }
    end
  end

  describe "#legal_moves_for" do
    before { board.add(piece: piece, at: position) }
    subject { board.legal_moves_for(board.piece_at(position)).map(&:to_s) }
    let(:board) { Board.new }

    context "when basic moves would move off the board" do
      let(:position) { "b1" }
      let(:piece) { Knight.new }

      it "filters out the illegal moves" do
        expect(subject).to match_array(['a3', 'c3', 'd2'])
      end
    end

    context "with advancing moves" do
      let(:position) { "b2" }
      let(:piece) { Rook.new }

      it "calculates moves to the end of the board" do
        expect(subject).to match_array([ 'b1', 'b3', 'b4', 'b5', 'b6', 'b7', 'b8',
                                         'a2', 'c2', 'd2', 'e2', 'f2', 'g2', 'h2' ])
      end
    end

    context "with a piece blocking the way" do
      before { board.add(piece: Rook.new, at: "b4") }

      context "with advancing moves" do
        let(:position) { "b2" }
        let(:piece) { Rook.new }

        it "calculates moves up to the blocking piece" do
          expect(subject).to match_array([ 'b1', 'b3', 'a2', 'c2', 'd2', 'e2', 'f2', 'g2', 'h2' ])
        end
      end

      context "with non-advancing moves" do
        let(:position) { "d3" }
        let(:piece) { Knight.new }

        it "filters out the illegal move" do
          expect(subject).to match_array(['b2', 'c1', 'c5', 'e1', 'e5', 'f2', 'f4'])
        end
      end
    end

    context "with a move that requires capture" do # eg pawn capture
      before { board.add(piece: other_piece, at: other_position) }
      let(:piece) { Pawn.new }
      let(:other_piece) { Rook.new }
      let(:other_position) { 'b4' }

      context "with an opposing piece occupying the position" do
        let(:other_piece) { Rook.new(side: :black) }
        let(:position) { 'a3' }

        it "should be a legal move" do
          expect(subject).to include(other_position)
        end
      end

      context "with a piece of the same color occupying the position" do
        let(:position) { 'a3' }

        it "should not be a legal move" do
          expect(subject).to_not include(other_position)
        end
      end

      context "with no piece occupying the position" do
        let(:position) { 'a4' }

        it "should not be a legal move" do
          expect(subject).to_not include(other_position)
        end
      end
    end
  end
end

