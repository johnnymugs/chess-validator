class Knight
  def possible_moves
    [
      PossibleMove.new(rank: +1, file: +2),
      PossibleMove.new(rank: +1, file: -2),
      PossibleMove.new(rank: -1, file: -2),
      PossibleMove.new(rank: -1, file: +2),
      PossibleMove.new(rank: +2, file: +1),
      PossibleMove.new(rank: +2, file: -1),
      PossibleMove.new(rank: -2, file: -1),
      PossibleMove.new(rank: -2, file: +1),
    ]
  end
end
