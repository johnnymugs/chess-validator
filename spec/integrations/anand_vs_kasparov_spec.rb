# Encoding: UTF-8
require 'spec_helper'

describe "Anand vs. Kasparov (1995)", integration: true do # from http://www.chessgames.com/perl/chessgame?gid=1018574
  let(:game) { Game.load_from_moves(moves) }
  let(:moves) { '1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6 6. Be2 e6 7. a4 Nc6 8. O-O Be7 9. Be3 O-O 10. f4 Qc7 11. Kh1 Re8 12. Qd2 Bd7 13. Rad1 Rad8 14. Nb3 Bc8 15. Bf3 b6 16. Qf2 Nd7 17. Nd4 Bb7 18. Bh5 Rf8 19. Qg3 Nxd4 20. Bxd4 Bf6 21. Be2 e5 22. fxe5 Bxe5 23. Qf2 Nc5 24. Bf3 Rfe8 25. h3 a5 26. Rfe1 Bc6 27. b3 h6' }
  let(:expected_output) do
    '8    ♜♜ ♚ ' + "\n" +
    '7   ♛  ♟♟ ' + "\n" +
    '6  ♟♝♟   ♟' + "\n" +
    '5 ♟ ♞ ♝   ' + "\n" +
    '4 ♙  ♗♙   ' + "\n" +
    '3  ♙♘  ♗ ♙' + "\n" +
    '2   ♙  ♕♙ ' + "\n" +
    '1    ♖♖  ♔' + "\n" +
    '  abcdefgh' + "\n"
  end

  it_should_behave_like "a valid game"
  it_should_behave_like "a serializable game"
end
