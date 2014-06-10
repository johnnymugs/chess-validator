class Knight < Piece
  def basic_moves
    [
      BasicMove.new(rank: +1, file: +2),
      BasicMove.new(rank: +1, file: -2),
      BasicMove.new(rank: -1, file: -2),
      BasicMove.new(rank: -1, file: +2),
      BasicMove.new(rank: +2, file: +1),
      BasicMove.new(rank: +2, file: -1),
      BasicMove.new(rank: -2, file: -1),
      BasicMove.new(rank: -2, file: +1),
    ]
  end

  def to_s
    @side == :white ? "\u2658" : "\u265E"
  end
end

