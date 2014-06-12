class Rook < Piece
  def basic_moves
    [
      BasicMove.new(file: '+n', rank: 0, piece: self),
      BasicMove.new(file: '-n', rank: 0, piece: self),
      BasicMove.new(file: 0, rank: '+n', piece: self),
      BasicMove.new(file: 0, rank: '-n', piece: self),
    ]
  end

  def to_s
    @side == :white ? "\u2656" : "\u265C"
  end
end

