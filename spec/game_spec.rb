require 'spec_helper'

describe Game do
  let(:game) { Game.new }

  describe "#new" do

    it "starts the game on white's turn" do
      expect(game.turn).to equal(:white)
    end
  end

  describe "#move" do
    before { game.move }

    context "when it's white's move" do
      it "changes the turn to black" do
        expect(game.turn).to equal(:black)
      end
    end

    context "when it's black's move" do
      before do
        expect(game.turn).to equal(:black)
        game.move
      end

      it "changes the turn to white" do
        expect(game.turn).to equal(:white)
      end
    end
  end
end
