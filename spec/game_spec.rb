require 'spec_helper'

describe Game do
  let(:game) { Game.new }

  describe "#new" do
    it "starts the game on white's turn" do
      expect(game.turn).to equal(:white)
    end
  end

  describe "#move!" do
    subject { -> { game.move!(move) } }
    let(:game) { Game.new(default: true) }
    let(:move) { 'e4' }

    it { should change { game.turn }.from(:white).to(:black) }
    it { should change { game.legal_moves.map(&:to_s) } }
    it { should change { game.board.piece_at('e2') } }

    it "should set the previous move" do
      subject.call
      expect(game.previous_move[:origin]).to eq('e2')
      expect(game.previous_move[:dest]).to eq('e4')
      expect(game.previous_move[:in_notation]).to eq('e4')
    end

    context "with a castling move" do
      let(:game) { Game.new }
      let(:move) { 'O-O' }

      before do
        game.board.add(piece: King.new, at: 'e1')
        game.board.add(piece: Rook.new, at: 'h1')
        game.board.add(piece: King.new(side: :black), at: 'e8') # necessary for move calculation
      end

      it { should change { game.turn }.from(:white).to(:black) }
      it { should change { game.legal_moves.map(&:to_s) } }
      it { should change { game.board.piece_at('e1') } }
      it { should change { game.board.piece_at('h1') } }
      it { should change { game.board.piece_at('f1') } }
      it { should change { game.board.piece_at('g1') } }

      it "should set the previous move" do
        subject.call

        expect(game.previous_move[:origin]).to eq('e1')
        expect(game.previous_move[:dest]).to eq('g1')
        expect(game.previous_move[:in_notation]).to eq('O-O')
        expect(game.previous_move[:secondary_move][:origin]).to eq('h1')
        expect(game.previous_move[:secondary_move][:dest]).to eq('f1')
      end
    end

    context "with a promotion" do
      let(:game) { Game.new }
      let(:move) { 'a8Q' }

      before do
        game.board.add(piece: King.new, at: 'e1')
        game.board.add(piece: Pawn.new, at: 'a7')
        game.board.add(piece: King.new(side: :black), at: 'e8') # necessary for move calculation
      end

      it { should change { game.turn }.from(:white).to(:black) }
      it { should change { game.legal_moves.map(&:to_s) } }
      it { should change { game.board.piece_at('a7') } }
      it { should change { game.board.piece_at('a8') } }
      it "should promote the piece" do
        subject.call
        expect(game.board.piece_at('a8').to_notation).to eq('Q')
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
        game.board.add(piece: Rook.new(side: :white), at: 'a6')
        game.move!('Ra7')
        expect(game.turn).to eq(:black)
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
        game.move!('e4')
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

      context "with a pawn capture" do
        before do
          game.board.add(piece: Pawn.new, at: 'b2')
          game.board.add(piece: Pawn.new(side: :black), at: 'c3')
        end

        it { should include('bxc3') } # include file in notation
      end

      context "with ambiguous moves" do
        context "with two pieces on different files" do
          before do
            game.board.add(piece: Rook.new, at: 'a4')
            game.board.add(piece: Rook.new, at: 'h4')
            game.board.add(piece: Knight.new, at: 'a6')
          end

          it "should include the file of departure" do
            expect(subject).to include('Rab4')
            expect(subject).to include('Rhb4')
          end

          it "should not include the file of departure for pieces that are already unambiguous" do
            expect(subject).to_not include('Nab4')
            expect(subject).to include('Nb4')
          end
        end

        context "with two pieces on the same file" do
          before do
            game.board.add(piece: Rook.new, at: 'c1')
            game.board.add(piece: Rook.new, at: 'c8')
            game.board.add(piece: Knight.new, at: 'd3')
          end

          it "should include the rank of departure" do
            expect(subject).to include('R1c5')
            expect(subject).to include('R8c5')
          end

          it "should not include the rank of departure for pieces that are already unambiguous" do
            expect(subject).to_not include('N3c5')
            expect(subject).to include('Nc5')
          end
        end

        context "in rare instances when rank or file alone will not sufficiently disambiguate" do
          before do
            game.board.add(piece: Queen.new, at: 'c8')
            game.board.add(piece: Queen.new, at: 'd8')
            game.board.add(piece: Queen.new, at: 'e8')
            game.board.add(piece: Queen.new, at: 'a7')
          end

          it "includes both rank and file" do
            expect(subject).to include('Qc8d7')
            expect(subject).to include('Qd8d7')
            expect(subject).to include('Qe8d7')
          end

          it "should not include both rank and file for moves which are otherwise unambiguous"
            # expect(subject).to_not include('Qa7d7')
            # expect(subject).to include('Qad7')
        end
      end
    end
  end

  describe "castling" do
    let(:game) { Game.new(default: false) }
    subject { game.legal_moves.map(&:to_notation) }

    context "when it is white's turn" do
      context "castling queenside" do
        before do
          game.board.add(piece: King.new, at: 'e1')
          game.board.add(piece: Rook.new, at: 'a1')
        end

        context "when the king has moved" do
          before { game.board.piece_at('e1').move! }

          it { should_not include('O-O-O') }
        end

        context "when the queenside rook has moved" do
          before { game.board.piece_at('a1').move! }

          it { should_not include('O-O-O') }
        end

        context "when there is a piece blocking the move" do
          before { game.board.add(piece: Knight.new, at: 'b1') }

          it { should_not include('O-O-O') }
        end

        context "when the king is in check" do
          before { game.board.add(piece: Rook.new(side: :black), at: 'e8') }

          it { should_not include('O-O-O') }
        end

        context "when castling would put the king in check" do
          before { game.board.add(piece: Rook.new(side: :black), at: 'c8') }

          it { should_not include('O-O-O') }
        end

        context "when the king is not in check, neither the king nor the rook has moved, and no pieces block the move" do
          it { should include('O-O-O') }
        end
      end

      context "castling kingside" do
        before do
          game.board.add(piece: King.new, at: 'e1')
          game.board.add(piece: Rook.new, at: 'h1')
        end

        context "when the king has moved" do
          before { game.board.piece_at('e1').move! }

          it { should_not include('O-O') }
        end

        context "when the queenside rook has moved" do
          before { game.board.piece_at('h1').move! }

          it { should_not include('O-O') }
        end

        context "when there is a piece blocking the move" do
          before { game.board.add(piece: Knight.new, at: 'f1') }

          it { should_not include('O-O') }
        end

        context "when the king is in check" do
          before { game.board.add(piece: Rook.new(side: :black), at: 'e8') }

          it { should_not include('O-O') }
        end

        context "when castling would put the king in check" do
          before { game.board.add(piece: Rook.new(side: :black), at: 'g8') }

          it { should_not include('O-O') }
        end

        context "when the king is not in check, neither the king nor the rook has moved, and no pieces block the move" do
          it { should include('O-O') }
        end
      end

      context "when white cannot castle but black can" do
        before do
          game.board.add(piece: King.new(side: :black), at: 'e8')
          game.board.add(piece: Rook.new(side: :black), at: 'h8')
          game.board.add(piece: King.new(moved: true), at: 'b1')
        end

        it { should_not include('O-O') }
        it { should_not include('O-O-O') }
      end
    end

    context "when it is black's turn" do
      let(:game) { Game.new(turn: :black) }

      context "castling queenside" do
        before do
          game.board.add(piece: King.new(side: :black), at: 'e8')
          game.board.add(piece: Rook.new(side: :black), at: 'a8')
        end

        context "when the king has moved" do
          before { game.board.piece_at('e8').move! }

          it { should_not include('O-O-O') }
        end

        context "when the queenside rook has moved" do
          before { game.board.piece_at('a8').move! }

          it { should_not include('O-O-O') }
        end

        context "when there is a piece blocking the move" do
          before { game.board.add(piece: Knight.new(side: :black), at: 'b8') }

          it { should_not include('O-O-O') }
        end

        context "when the king is in check" do
          before { game.board.add(piece: Rook.new, at: 'e1') }

          it { should_not include('O-O-O') }
        end

        context "when castling would put the king in check" do
          before { game.board.add(piece: Rook.new, at: 'c1') }

          it { should_not include('O-O-O') }
        end

        context "when the king is not in check, neither the king nor the rook has moved, and no pieces block the move" do
          it { should include('O-O-O') }
        end
      end

      context "castling kingside" do
        before do
          game.board.add(piece: King.new(side: :black), at: 'e8')
          game.board.add(piece: Rook.new(side: :black), at: 'h8')
        end

        context "when the king has moved" do
          before { game.board.piece_at('e8').move! }

          it { should_not include('O-O') }
        end

        context "when the queenside rook has moved" do
          before { game.board.piece_at('h8').move! }

          it { should_not include('O-O') }
        end

        context "when there is a piece blocking the move" do
          before { game.board.add(piece: Knight.new(side: :black), at: 'f8') }

          it { should_not include('O-O') }
        end

        context "when the king is in check" do
          before { game.board.add(piece: Rook.new, at: 'e1') }

          it { should_not include('O-O') }
        end

        context "when castling would put the king in check" do
          before { game.board.add(piece: Rook.new, at: 'g8') }

          it { should_not include('O-O') }
        end

        context "when the king is not in check, neither the king nor the rook has moved, and no pieces block the move" do
          it { should include('O-O') }
        end
      end

      context "when black cannot castle but white can" do
        before do
          game.board.add(piece: King.new, at: 'e1')
          game.board.add(piece: Rook.new, at: 'h1')
          game.board.add(piece: King.new(side: :black, moved: true), at: 'f8')
        end

        it { should_not include('O-O') }
        it { should_not include('O-O-O') }
      end
    end
  end

  describe "pawn promotion" do
    subject { game.legal_moves.map(&:to_notation) }

    context "when it is white's turn" do
      before { game.board.add(piece: King.new, at: 'e4') } # for legal move calculation
      let(:game) { Game.new(default: false) }

      context "when a pawn is able to reach the back rank" do
        before { game.board.add(piece: Pawn.new, at: 'e7') }

        it "should not include the normal move" do
          expect(subject).to_not include('e8')
        end

        it "should include the promotion to Q, R, B, and N" do
          expect(subject).to include('e8Q')
          expect(subject).to include('e8R')
          expect(subject).to include('e8B')
          expect(subject).to include('e8N')
        end
      end

      context "when a pawn is able to reach the back rank with capture" do
        before do
          game.board.add(piece: Pawn.new, at: 'e7')
          game.board.add(piece: Knight.new(side: :black), at: 'd8')
        end

        it "should not include the normal move" do
          expect(subject).to_not include('e8')
        end

        it "should include the promotion to Q, R, B, and N" do
          expect(subject).to include('e8Q')
          expect(subject).to include('e8R')
          expect(subject).to include('e8B')
          expect(subject).to include('e8N')
        end

        it "should include the promotion to Q, R, B, and N through capture" do
          expect(subject).to include('exd8Q')
          expect(subject).to include('exd8R')
          expect(subject).to include('exd8B')
          expect(subject).to include('exd8N')
        end
      end

      context "when a pawn is unable to reach the back rank" do
        before do
          game.board.add(piece: Pawn.new, at: 'e7')
          game.board.add(piece: Knight.new(side: :black), at: 'e8')
        end

        it "should not include promotion moves" do
          expect(subject).to_not include('e8')
          expect(subject).to_not include('e8Q')
          expect(subject).to_not include('e8R')
          expect(subject).to_not include('e8B')
          expect(subject).to_not include('e8N')
        end
      end
    end

    context "when it is black's turn" do
      before { game.board.add(piece: King.new(side: :black), at: 'e4') } # for legal move calculation
      let(:game) { Game.new(default: false, turn: :black) }

      context "when a pawn is able to reach the back rank" do
        before { game.board.add(piece: Pawn.new(side: :black), at: 'e2') }

        it "should not include the normal move" do
          expect(subject).to_not include('e1')
        end

        it "should include the promotion to Q, R, B, and N" do
          expect(subject).to include('e1Q')
          expect(subject).to include('e1R')
          expect(subject).to include('e1B')
          expect(subject).to include('e1N')
        end
      end

      context "when a pawn is able to reach the back rank with capture" do
        before do
          game.board.add(piece: Pawn.new(side: :black), at: 'e2')
          game.board.add(piece: Knight.new(side: :white), at: 'd1')
        end

        it "should not include the normal move" do
          expect(subject).to_not include('e1')
        end

        it "should include the promotion to Q, R, B, and N" do
          expect(subject).to include('e1Q')
          expect(subject).to include('e1R')
          expect(subject).to include('e1B')
          expect(subject).to include('e1N')
        end

        it "should include the promotion to Q, R, B, and N through capture" do
          expect(subject).to include('exd1Q')
          expect(subject).to include('exd1R')
          expect(subject).to include('exd1B')
          expect(subject).to include('exd1N')
        end
      end

      context "when a pawn is unable to reach the back rank" do
        before do
          game.board.add(piece: Pawn.new(side: :black), at: 'e2')
          game.board.add(piece: Knight.new(side: :white), at: 'e1')
        end

        it "should not include promotion moves" do
          expect(subject).to_not include('e1')
          expect(subject).to_not include('e1Q')
          expect(subject).to_not include('e1R')
          expect(subject).to_not include('e1B')
          expect(subject).to_not include('e1N')
        end
      end
    end
  end

  describe "#legal_move?" do
    subject { game.legal_move?(move) }
    let(:game) { Game.new(default: true) }

    context "with a legal move" do
      let(:move) { 'e4' }
      it { should be_truthy }
    end

    context "with an illegal move" do
      let(:move) { 'e7' }
      it { should be_falsy }
    end
  end

  describe "#ambiguous_move_matches_for" do
    subject { game.ambiguous_move_matches_for(move) }

    let(:game) { Game.new }
    let(:move) { 'c4' }

    before do
      game.board.add(piece: Rook.new, at: 'a4')
      game.board.add(piece: Rook.new, at: 'h4')
    end

    it { should eq(['Rac4', 'Rhc4']) }
  end
end

