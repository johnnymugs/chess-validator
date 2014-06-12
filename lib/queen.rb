class Queen < Piece
  def basic_moves
    [
      BasicMove.new(rank: '+n', file: 0, piece: self),
      BasicMove.new(rank: '-n', file: 0, piece: self),
      BasicMove.new(rank: 0, file: '+n', piece: self),
      BasicMove.new(rank: 0, file: '-n', piece: self),
      BasicMove.new(rank: '+n', file: '+n', piece: self),
      BasicMove.new(rank: '+n', file: '-n', piece: self),
      BasicMove.new(rank: '-n', file: '-n', piece: self),
      BasicMove.new(rank: '-n', file: '+n', piece: self)
    ]
  end

  def to_s
    @side == :white ? "\u2655" : "\u265B"
  end
end

