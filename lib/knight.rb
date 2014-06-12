class Knight < Piece
  def basic_moves
    [
      BasicMove.new(rank: +1, file: +2, piece: self),
      BasicMove.new(rank: +1, file: -2, piece: self),
      BasicMove.new(rank: -1, file: -2, piece: self),
      BasicMove.new(rank: -1, file: +2, piece: self),
      BasicMove.new(rank: +2, file: +1, piece: self),
      BasicMove.new(rank: +2, file: -1, piece: self),
      BasicMove.new(rank: -2, file: -1, piece: self),
      BasicMove.new(rank: -2, file: +1, piece: self)
    ]
  end

  def to_s
    @side == :white ? "\u2658" : "\u265E"
  end
end

