class Bishop < Piece
  def basic_moves
    [
      BasicMove.new(rank: '+n', file: '+n'),
      BasicMove.new(rank: '+n', file: '-n'),
      BasicMove.new(rank: '-n', file: '-n'),
      BasicMove.new(rank: '-n', file: '+n')
    ]
  end

  def to_s
    @side == :white ? "\u2657" : "\u265D"
  end
end

