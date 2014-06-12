class Pawn < Piece
  def basic_moves
    moves = [
      BasicMove.new(rank: +1, file: 0, can_capture: false, piece: self),
      BasicMove.new(rank: +1, file: +1, requires_capture: true, piece: self),
      BasicMove.new(rank: +1, file: -1, requires_capture: true, piece: self),
    ]
    moves << BasicMove.new(rank: +2, file: 0, can_capture: false, piece: self) if !moved?
    moves
  end

  def to_s
    @side == :white ? "\u2659" : "\u265F"
  end

  def to_notation
    ""
  end
end

