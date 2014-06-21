require 'spec_helper'

describe "Sutovsky vs Morozevich (1998)", integration: true do # from http://www.chessgames.com/perl/chessgame?gid=1408089
  let(:game) { Game.load_from_moves(moves) }
  let(:moves) { '1. e4 e6 2. d4 d5 3. Nc3 Nf6 4. Bg5 dxe4 5. Nxe4 Be7 6. Bxf6 gxf6 7. Nf3 a6 8. Qd2 b5 9. Qh6 Bb7 10. Bd3 Nd7 11. Ng3 f5 12. Nh5 Bf8 13. Qe3 Nf6 14. Qe5 Nxh5 15. Qxh8 Bxf3 16. gxf3 Nf6 17. Rg1 Qxd4 18. Rg8 Ke7 19. Kf1 Bg7 20. Qxg7 Rxg8 21. Qh6 Qxb2 22. Re1 Qc3 23. Qh4 c5 24. Rd1 c4 25. Bxf5 Qxf3 26. Qd4 Nd5' }
  let(:expected_output) do
    '8       ♜ ' + "\n" +
    '7     ♚♟ ♟' + "\n" +
    '6 ♟   ♟   ' + "\n" +
    '5  ♟ ♞ ♗  ' + "\n" +
    '4   ♟♕    ' + "\n" +
    '3      ♛  ' + "\n" +
    '2 ♙ ♙  ♙ ♙' + "\n" +
    '1    ♖ ♔  ' + "\n" +
    '  abcdefgh' + "\n"
  end

  it_should_behave_like "a valid game"
  it_should_behave_like "a serializable game"
end

