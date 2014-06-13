# Encoding: UTF-8
require 'spec_helper'

describe "a few simple moves" do
  let(:game) { Game.load_from_moves(moves) }
  let(:moves) { '1. e4 e6 2. d4 d5 3. Nc3 Nf6' }
  let(:expected_output) do
    '8 ♜♞♝♛♚♝ ♜' + "\n" +
    '7 ♟♟♟  ♟♟♟' + "\n" +
    '6     ♟♞  ' + "\n" +
    '5    ♟    ' + "\n" +
    '4    ♙♙   ' + "\n" +
    '3   ♘     ' + "\n" +
    '2 ♙♙♙  ♙♙♙' + "\n" +
    '1 ♖ ♗♕♔♗♘♖' + "\n" +
    '  abcdefgh' + "\n"
  end

  it "should run the game as expected" do
    expect(game.board.to_s).to eq(expected_output)
  end
end

