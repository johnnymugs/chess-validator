class BoardPrinter
  def initialize(board)
    @board = board
  end

  def print
    output = ""
    8.downto(1) do |rank|
      output << rank.to_s + " "
      ('a'..'h').each do |file|
        piece = @board.piece_at(file + rank.to_s)
        output << (piece ? piece.to_s : " ")
      end
      output << "\n"
    end
    output << footer
  end

  private

  def footer
    "          \n" +
    "  abcdefgh\n"
  end
end

