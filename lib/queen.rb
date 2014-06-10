class Queen < Piece
  def basic_moves
    [
      BasicMove.new(rank: '+n', file: 0),
      BasicMove.new(rank: '-n', file: 0),
      BasicMove.new(rank: 0, file: '+n'),
      BasicMove.new(rank: 0, file: '-n'),
      BasicMove.new(rank: '+n', file: '+n'),
      BasicMove.new(rank: '+n', file: '-n'),
      BasicMove.new(rank: '-n', file: '-n'),
      BasicMove.new(rank: '-n', file: '+n')
    ]
  end

  def to_s
    @side == :white ? "\u2655" : "\u265B"
  end
end

