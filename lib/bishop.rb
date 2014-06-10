class Bishop
  def basic_moves
    [
      BasicMove.new(rank: '+n', file: '+n'),
      BasicMove.new(rank: '+n', file: '-n'),
      BasicMove.new(rank: '-n', file: '-n'),
      BasicMove.new(rank: '-n', file: '+n')
    ]
  end
end

