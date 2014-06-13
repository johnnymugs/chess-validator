require 'spec_helper'

describe Game do
  let(:game) { Game.new }

  describe "#new" do
    it "starts the game on white's turn" do
      expect(game.turn).to equal(:white)
    end
  end

  describe "#move" do
    before { game.move! }

    context "when it's white's move" do
      it "changes the turn to black" do
        expect(game.turn).to equal(:black)
      end
    end

    context "when it's black's move" do
      before do
        expect(game.turn).to equal(:black)
        game.move!
      end

      it "changes the turn to white" do
        expect(game.turn).to equal(:white)
      end
    end
  end

  describe "#check?" do
    subject { game.check? }
    before do
      game.board.add(piece: King.new(side: :white), at: 'a1')
      game.board.add(piece: King.new(side: :black), at: 'a8')
    end
    let(:game) { Game.new }

    context "when white is in check" do
      before do
        expect(game.turn).to eq(:white)
        game.board.add(piece: Rook.new(side: :black), at: 'a7')
      end
      it { should be_truthy }
    end

    context "when black is in check" do
      before do
        game.move!
        expect(game.turn).to eq(:black)
        game.board.add(piece: Rook.new(side: :white), at: 'a7')
      end
      it { should be_truthy }
    end
  end

  describe "#checkmate?" do
    subject { game.checkmate? }
    before { game.board.add(piece: King.new(side: :white), at: 'a1') }
    let(:game) { Game.new }

    context "when the king is not under attack" do
      it { should be_falsy }
    end

    context "when the king is under attack but has moves left" do
      before { game.board.add(piece: Rook.new(side: :black), at: 'a8') }
      it { should be_falsy }
    end

    context "when the king is under attack and cannot escape" do
      before do
        game.board.add(piece: Queen.new(side: :black), at: 'a8')
        game.board.add(piece: Rook.new(side: :black), at: 'b8')
      end
      it { should be_truthy }
    end

    context "when the king is in stalemate" do
      before do
        game.board.add(piece: Queen.new(side: :black), at: 'a8')
        game.board.add(piece: Rook.new(side: :black), at: 'b8')
        game.board.add(piece: Bishop.new(side: :black), at: 'a2')
      end

      it { should be_falsy }
    end
  end

  describe "#stalemate?" do
    subject { game.stalemate? }
    before { game.board.add(piece: King.new(side: :white), at: 'a1') }
    let(:game) { Game.new }

    context "when there are legal moves available" do
      before { game.board.add(piece: Rook.new(side: :black), at: 'a8') }
      it { should be_falsy }
    end

    context "when the king is in checkmate" do
      before do
        game.board.add(piece: Queen.new(side: :black), at: 'a8')
        game.board.add(piece: Rook.new(side: :black), at: 'b8')
      end
      it { should be_falsy }
    end

    context "when there are no legal moves but the king is not in checkmate" do
      before do
        game.board.add(piece: Queen.new(side: :black), at: 'a8')
        game.board.add(piece: Rook.new(side: :black), at: 'b8')
        game.board.add(piece: Bishop.new(side: :black), at: 'a2')
      end

      it { should be_truthy }
    end
  end

  describe "#legal_moves" do
    let(:game) { Game.new(default: true) }

    context "when it's white's turn" do
      before { expect(game.turn).to eq(:white) }

      it "should be the board's possible moves for white" do
        expect(game.legal_moves).to eq(game.board.possible_moves_for(:white))
      end
    end

    context "when it's black's turn" do
      before do
        game.move!
        expect(game.turn).to eq(:black)
      end

      it "should be the board's possible moves for black" do
        expect(game.legal_moves).to eq(game.board.possible_moves_for(:black))
      end
    end

    context "with a move that would put the king in check" do
      let(:game) { Game.new }
      before do
        game.board.add(piece: King.new(side: :white), at: 'a1')
        game.board.add(piece: Rook.new(side: :black), at: 'b8')
      end

      it "should not include the move in the list of legal moves" do
        expect(game.legal_moves.map(&:to_s)).to_not include('b1')
      end
    end

    describe "notation" do
      subject { game.legal_moves.map(&:to_notation) }
      let(:game) { Game.new }
      before do
        game.board.add(piece: King.new(side: :white), at: 'a1')
        game.board.add(piece: Rook.new(side: :black), at: 'b8')
      end


      context "with a pawn" do
        before { game.board.add(piece: Pawn.new, at: 'b2') }

        it { should include('b3') }
      end

      context "with a piece" do
        before { game.board.add(piece: Rook.new, at: 'b2') }

        it { should include('Rb3') }
      end

      context "with a capture" do
        before do
          game.board.add(piece: Rook.new, at: 'b2')
          game.board.add(piece: Rook.new(side: :black), at: 'b4')
        end

        it { should include('Rxb4') }
      end
    end
  end
end

