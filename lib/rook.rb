class Rook < Piece
  def basic_moves
    [
      BasicMove.new(file: '+n', rank: 0),
      BasicMove.new(file: '-n', rank: 0),
      BasicMove.new(file: 0, rank: '+n'),
      BasicMove.new(file: 0, rank: '-n')
    ]
  end

  def to_s
    @side == :white ? "\u2656" : "\u265C"
  end
end

