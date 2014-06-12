class Game
  attr_reader :board, :turn

  def initialize(default: false)
    @turn = :white
    @board = Board.new

    set_up_default_board if default
  end

  def move!
    @turn = @turn == :white ? :black : :white
  end

  def check?
    board.possible_moves_for(:black).include?(board.king_position(:white)) ||
      board.possible_moves_for(:white).include?(board.king_position(:black))
  end

  private

  def set_up_default_board
    @board.add(piece: Rook.new, at: 'a1')
    @board.add(piece: Knight.new, at: 'b1')
    @board.add(piece: Bishop.new, at: 'c1')
    @board.add(piece: Queen.new, at: 'd1')
    @board.add(piece: King.new, at: 'e1')
    @board.add(piece: Bishop.new, at: 'f1')
    @board.add(piece: Knight.new, at: 'g1')
    @board.add(piece: Rook.new, at: 'h1')

    @board.add(piece: Pawn.new, at: 'a2')
    @board.add(piece: Pawn.new, at: 'b2')
    @board.add(piece: Pawn.new, at: 'c2')
    @board.add(piece: Pawn.new, at: 'd2')
    @board.add(piece: Pawn.new, at: 'e2')
    @board.add(piece: Pawn.new, at: 'f2')
    @board.add(piece: Pawn.new, at: 'g2')
    @board.add(piece: Pawn.new, at: 'h2')

    @board.add(piece: Rook.new(side: :black), at: 'a8')
    @board.add(piece: Knight.new(side: :black), at: 'b8')
    @board.add(piece: Bishop.new(side: :black), at: 'c8')
    @board.add(piece: Queen.new(side: :black), at: 'd8')
    @board.add(piece: King.new(side: :black), at: 'e8')
    @board.add(piece: Bishop.new(side: :black), at: 'f8')
    @board.add(piece: Knight.new(side: :black), at: 'g8')
    @board.add(piece: Rook.new(side: :black), at: 'h8')

    @board.add(piece: Pawn.new(side: :black), at: 'a7')
    @board.add(piece: Pawn.new(side: :black), at: 'b7')
    @board.add(piece: Pawn.new(side: :black), at: 'c7')
    @board.add(piece: Pawn.new(side: :black), at: 'd7')
    @board.add(piece: Pawn.new(side: :black), at: 'e7')
    @board.add(piece: Pawn.new(side: :black), at: 'f7')
    @board.add(piece: Pawn.new(side: :black), at: 'g7')
    @board.add(piece: Pawn.new(side: :black), at: 'h7')
  end
end

