require 'spec_helper'

describe BoardPrinter do
  describe "#print" do
    subject { BoardPrinter.new(board).print }
    let(:board) { Board.new }
    let(:output) do
      "8 \u265C\u265E\u265D\u265B\u265A   \n" +
      "7         \n" +
      "6         \n" +
      "5         \n" +
      "4         \n" +
      "3         \n" +
      "2         \n" +
      "1 \u2656\u2658\u2657\u2655\u2654   \n" +
      "          \n" +
      "  abcdefgh\n"
    end

    before do
      board.add(piece: Rook.new, at: 'a1')
      board.add(piece: Knight.new, at: 'b1')
      board.add(piece: Bishop.new, at: 'c1')
      board.add(piece: Queen.new, at: 'd1')
      board.add(piece: King.new, at: 'e1')

      board.add(piece: Rook.new(side: :black), at: 'a8')
      board.add(piece: Knight.new(side: :black), at: 'b8')
      board.add(piece: Bishop.new(side: :black), at: 'c8')
      board.add(piece: Queen.new(side: :black), at: 'd8')
      board.add(piece: King.new(side: :black), at: 'e8')
    end

    it { should == output }
  end
end

