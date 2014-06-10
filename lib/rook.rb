class Rook
  def basic_moves
    [
      BasicMove.new(file: '+n', rank: 0),
      BasicMove.new(file: '-n', rank: 0),
      BasicMove.new(file: 0, rank: '+n'),
      BasicMove.new(file: 0, rank: '-n')
    ]
  end
end

