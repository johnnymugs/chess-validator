class Pawn < Piece
  def basic_moves
    direction = @side == :white ? +1 : -1
    moves = [
      BasicMove.new(rank: 1 * direction, file: 0, can_capture: false, piece: self),
      BasicMove.new(rank: 1 * direction, file: +1, requires_capture: true, piece: self),
      BasicMove.new(rank: 1 * direction, file: -1, requires_capture: true, piece: self)
    ]
    moves << BasicMove.new(rank: 2 * direction, file: 0, can_capture: false, piece: self) if !moved?
    moves
  end

  def to_s
    @side == :white ? "\u2659" : "\u265F"
  end

  def to_notation
    ""
  end
end

