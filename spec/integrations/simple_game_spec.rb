require 'spec_helper'

describe "a few simple moves", integration: true do
  let(:game) { Game.load_from_moves(moves) }
  let(:moves) { '1. e4 e6 2. d4 d5 3. Nc3' }
  let(:expected_output) do
    '8 ♜♞♝♛♚♝♞♜' + "\n" +
    '7 ♟♟♟  ♟♟♟' + "\n" +
    '6     ♟   ' + "\n" +
    '5    ♟    ' + "\n" +
    '4    ♙♙   ' + "\n" +
    '3   ♘     ' + "\n" +
    '2 ♙♙♙  ♙♙♙' + "\n" +
    '1 ♖ ♗♕♔♗♘♖' + "\n" +
    '  abcdefgh' + "\n"
  end

  it_should_behave_like "a valid game"
end

