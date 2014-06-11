class Board
  attr_reader :pieces

  def initialize
    @pieces = {}
  end

  def piece_at(position)
    @pieces[position]
  end

  def add(piece:, at:)
    raise RuntimeError.new("#{at} is not a valid position") unless is_valid_position?(at)
    raise RuntimeError.new("There is already a piece at #{at}") unless @pieces[at].nil?

    @pieces[at] = piece
  end

  def legal_moves_for(piece, at_position:nil)
    piece_position = at_position || position_for_piece(piece)

    legal_moves = []
    piece.basic_moves.each do |move|
      step = 1
      loop do
        next_move = move.from_position(piece_position, step: step)
        break unless is_within_bounds?(next_move) && can_occupy_position?(piece, next_move)
        legal_moves << next_move
        break if piece_at(next_move)
        break unless move.takes_steps?
        step += 1
      end
    end

    legal_moves
  end

  def legal_moves
    @pieces.map do |position, piece|
      legal_moves_for(piece, at_position: Position.new(position))
    end.flatten
  end

  def print
    BoardPrinter.new(self).print
  end

  private

  def is_within_bounds?(position)
    (1..8).include?(position.rank) && (1..8).include?(position.file)
  end

  def is_valid_position?(position)
    file = position[0] # a...h
    rank = position[1] # 1...8
    ('a'..'h').include?(file.downcase) && ('1'..'8').include?(rank)
  end

  def position_for_piece(piece)
    @pieces.map{ |k,v| Position.new(k) if v == piece }.first || raise(RuntimeError.new("Piece not found on board"))
  end

  def can_occupy_position?(piece, move)
    !piece_at(move.to_s) ||
      (move.requires_capture? && piece_at(move.to_s).side != piece.side) ||
      (move.can_capture? && piece_at(move.to_s).side != piece.side)
  end
end

class Board
  def self.default_setup # this is hacky but I just don't want to look at this crappy helper method
    board = new
    board.add(piece: Rook.new, at: 'a1')
    board.add(piece: Knight.new, at: 'b1')
    board.add(piece: Bishop.new, at: 'c1')
    board.add(piece: Queen.new, at: 'd1')
    board.add(piece: King.new, at: 'e1')
    board.add(piece: Bishop.new, at: 'f1')
    board.add(piece: Knight.new, at: 'g1')
    board.add(piece: Rook.new, at: 'h1')

    board.add(piece: Pawn.new, at: 'a2')
    board.add(piece: Pawn.new, at: 'b2')
    board.add(piece: Pawn.new, at: 'c2')
    board.add(piece: Pawn.new, at: 'd2')
    board.add(piece: Pawn.new, at: 'e2')
    board.add(piece: Pawn.new, at: 'f2')
    board.add(piece: Pawn.new, at: 'g2')
    board.add(piece: Pawn.new, at: 'h2')

    board.add(piece: Rook.new(side: :black), at: 'a8')
    board.add(piece: Knight.new(side: :black), at: 'b8')
    board.add(piece: Bishop.new(side: :black), at: 'c8')
    board.add(piece: Queen.new(side: :black), at: 'd8')
    board.add(piece: King.new(side: :black), at: 'e8')
    board.add(piece: Bishop.new(side: :black), at: 'f8')
    board.add(piece: Knight.new(side: :black), at: 'g8')
    board.add(piece: Rook.new(side: :black), at: 'h8')

    board.add(piece: Pawn.new(side: :black), at: 'a7')
    board.add(piece: Pawn.new(side: :black), at: 'b7')
    board.add(piece: Pawn.new(side: :black), at: 'c7')
    board.add(piece: Pawn.new(side: :black), at: 'd7')
    board.add(piece: Pawn.new(side: :black), at: 'e7')
    board.add(piece: Pawn.new(side: :black), at: 'f7')
    board.add(piece: Pawn.new(side: :black), at: 'g7')
    board.add(piece: Pawn.new(side: :black), at: 'h7')

    board
  end

end

