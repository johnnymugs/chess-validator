class King
  def basic_moves
    [
      BasicMove.new(rank: +1, file: 0),
      BasicMove.new(rank: -1, file: 0),
      BasicMove.new(rank: 0, file: +1),
      BasicMove.new(rank: 0, file: -1),
      BasicMove.new(rank: +1, file: +1),
      BasicMove.new(rank: +1, file: -1),
      BasicMove.new(rank: -1, file: -1),
      BasicMove.new(rank: -1, file: +1)
    ]
  end
end

