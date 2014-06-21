require 'spec_helper'

describe "Mestovic vs. Gligoric (1971)", integration: true do # a good test for pawn promotion, from http://www.chessgames.com/perl/chessgame?gid=1158884
  let(:game) { Game.load_from_moves(moves) }
  let(:moves) { '1. d4 Nf6 2. Nc3 d5 3. Bg5 c5 4. Bxf6 gxf6 5. e4 dxe4 6. dxc5 Qa5 7. Qh5 Bg7 8. Bb5 Nc6 9. Ne2 O-O 10. a3 f5 11. O-O Qc7 12. b4 Be6 13. Rad1 Rad8 14. Ba4 a5 15. Nb5 Qe5 16. c3 axb4 17. axb4 Bc4 18. Rxd8 Rxd8 19. Nbd4 Nxd4 20. cxd4 Qf6 21. Rc1 Qa6 22. Bd1 Qa2 23. h3 Bd3 24. Ng3 Qd2 25. Nxf5 e3 26. Nxe7 Kh8 27. Qh4 exf2 28. Kh2 Rxd4 29. Qg3 f1N' }
  let(:expected_output) do
    '8        ♚' + "\n" +
    '7  ♟  ♘♟♝♟' + "\n" +
    '6         ' + "\n" +
    '5   ♙     ' + "\n" +
    '4  ♙ ♜    ' + "\n" +
    '3    ♝  ♕♙' + "\n" +
    '2    ♛  ♙♔' + "\n" +
    '1   ♖♗ ♞  ' + "\n" +
    '  abcdefgh' + "\n"
  end

  it_should_behave_like "a valid game"
end

