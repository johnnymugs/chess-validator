class Knight
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
end
