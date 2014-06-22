require 'spec_helper'

# this game features:
# - check
# - checkmate
# - ambiguous moves (Nfxd2, etc.)
# - castling

describe "Steinkuehler vs Blackburne (1863)", integration: true do # from: http://www.chessgames.com/perl/chessgame?gid=1028832
  let(:game) { Game.load_from_moves(moves) }
  let(:moves) { '1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. c3 Nf6 5. d4 exd4 6. cxd4 Bb4+ 7. Bd2 Bxd2+ 8. Nfxd2 Nxd4 9. O-O d6 10. Nb3 Nxb3 11. Qxb3 O-O 12. Re1 Nh5 13. e5 Qg5 14. exd6 Nf4 15. Bxf7+ Kh8 16. g3 cxd6 17. Nc3 Nh3+ 18. Kg2 Qf6 19. Bd5 Qxf2+ 20. Kh1 Qg1+ 21. Rxg1 Nf2+ 22. Kg2 Bh3#' }
  let(:expected_output) do
    '8 ♜    ♜ ♚' + "\n" +
    '7 ♟♟    ♟♟' + "\n" +
    '6    ♟    ' + "\n" +
    '5    ♗    ' + "\n" +
    '4         ' + "\n" +
    '3  ♕♘   ♙♝' + "\n" +
    '2 ♙♙   ♞♔♙' + "\n" +
    '1 ♖     ♖ ' + "\n" +
    '  abcdefgh' + "\n"
  end

  it_should_behave_like "a valid game"
end

