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

    context "when neither white nor black is in check" do
      it { should be_falsy }
    end

    context "when white is in check" do
      before { game.board.add(piece: Rook.new(side: :black), at: 'a7') }
      it { should be_truthy }
    end

    context "when black is in check" do
      before { game.board.add(piece: Rook.new(side: :white), at: 'a7') }
      it { should be_truthy }
    end
  end
end

