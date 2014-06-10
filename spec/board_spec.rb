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
    before { board.add(piece: Knight.new, at: position) }
    subject { board.legal_moves_for(board.piece_at(position)).map(&:to_s) }
    let(:board) { Board.new }

    context "when basic moves would move off the board" do
      let(:position) { "b1" }
      it "filters out the illegal moves" do
        expect(subject).to match_array(['a3', 'c3', 'd2'])
      end
    end
  end
end

