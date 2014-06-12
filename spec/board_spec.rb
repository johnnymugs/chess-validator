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

  describe "#possible_moves_for_piece" do
    before { board.add(piece: piece, at: position) }
    subject { board.possible_moves_for_piece(board.piece_at(position)).map(&:to_s) }
    let(:board) { Board.new }

    context "when basic moves would move off the board" do
      let(:position) { "b1" }
      let(:piece) { Knight.new }

      it "filters out the out of bounds moves" do
        expect(subject).to match_array(%w{ a3 c3 d2 })
      end
    end

    context "with advancing moves" do
      let(:position) { "b2" }
      let(:piece) { Rook.new }

      it "calculates moves to the end of the board" do
        expect(subject).to match_array(%w{ b1 b3 b4 b5 b6 b7 b8 a2 c2 d2 e2 f2 g2 h2 })
      end
    end

    context "with a piece of the same color blocking the way" do
      before { board.add(piece: Rook.new, at: "b4") }

      context "with advancing moves" do
        let(:position) { "b2" }
        let(:piece) { Rook.new }

        it "calculates moves up to the blocking piece" do
          expect(subject).to match_array(%w{ b1 b3 a2 c2 d2 e2 f2 g2 h2 })
        end
      end

      context "with non-advancing moves" do
        let(:position) { "d3" }
        let(:piece) { Knight.new }

        it "filters out the move" do
          expect(subject).to match_array(%w{ b2 c1 c5 e1 e5 f2 f4 })
        end
      end
    end

    context "with a move that requires capture" do # eg pawn capture
      let(:piece) { Pawn.new }
      let(:position) { 'a3' }
      let(:other_piece) { Rook.new }
      let(:other_position) { 'b4' }

      context "with an opposing piece occupying the position" do
        let(:other_piece) { Rook.new(side: :black) }
        before { board.add(piece: other_piece, at: other_position) }

        it "should be a possible move" do
          expect(subject).to include(other_position)
        end
      end

      context "with a piece of the same color occupying the position" do
        before { board.add(piece: other_piece, at: other_position) }

        it "should not be a possible move" do
          expect(subject).to_not include(other_position)
        end
      end

      context "with no piece occupying the position" do
        before { expect(board.piece_at(other_position)).to be_nil }

        it "should not be a possible move" do
          expect(subject).to_not include(other_position)
        end
      end
    end

    context "with an opposing piece occupying the position" do
      before { board.add(piece: other_piece, at: other_position) }
      let(:other_piece) { Rook.new(side: :black) }
      let(:other_position) { 'b4' }
      let(:position) { 'b3' }

      context "with a move that can capture" do
        let(:piece) { Rook.new }

        it "should be a possible move" do
          expect(subject).to include(other_position)
        end
      end

      context "with a move that cannot capture and an opposing piece" do # eg pawn advancing
        let(:piece) { Pawn.new }

        it "should not be a possible move" do
          expect(subject).to_not include(other_position)
        end
      end
    end
  end

  describe "#possible_moves_for" do
    subject { board.possible_moves_for(side).map(&:to_s) }
    let(:board) { Board.new }
    let(:white_rook) { Rook.new(side: :white) }
    let(:black_rook) { Rook.new(side: :black) }

    before do
      board.add(piece: white_rook, at: "a1")
      board.add(piece: black_rook, at: "a8")
    end

    context "white side" do
      let(:side) { :white }

      it "only includes white pieces" do
        expect(subject).to match_array(board.possible_moves_for_piece(white_rook).map(&:to_s))
      end
    end

    context "black side" do
      let(:side) { :black }

      it "only includes black pieces" do
        expect(subject).to match_array(board.possible_moves_for_piece(black_rook).map(&:to_s))
      end
    end
  end

  describe "#king_position" do
    subject { board.king_position(side).to_s }
    let(:white_position) { 'c4' }
    let(:black_position) { 'd8' }
    let(:board) { Board.new }

    before do
      board.add(piece: King.new(side: :white), at: white_position)
      board.add(piece: King.new(side: :black), at: black_position)
    end

    context "white side" do
      let(:side) { :white }

      it "indicates the white king's position" do
        expect(subject).to eq(white_position)
      end
    end

    context "black side" do
      let(:side) { :black }

      it "indicates the black king's position" do
        expect(subject).to eq(black_position)
      end
    end
  end
end

