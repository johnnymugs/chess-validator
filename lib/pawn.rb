class Pawn < Piece
  def basic_moves
    direction = @side == :white ? +1 : -1
    n_direction = @side == :white ? '+n' : '-n'
    max_steps = moved? ? 1 : 2
    [
      BasicMove.new(rank: n_direction, file: 0, can_capture: false, piece: self, max_steps: max_steps),
      BasicMove.new(rank: 1 * direction, file: +1, requires_capture: true, piece: self),
      BasicMove.new(rank: 1 * direction, file: -1, requires_capture: true, piece: self)
    ]
  end

  def to_s
    @side == :white ? "\u2659" : "\u265F"
  end

  def to_notation
    ""
  end
end

