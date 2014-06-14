module CV
  class Bishop < Piece
    def basic_moves
      [
        BasicMove.new(rank: '+n', file: '+n', piece: self),
        BasicMove.new(rank: '+n', file: '-n', piece: self),
        BasicMove.new(rank: '-n', file: '-n', piece: self),
        BasicMove.new(rank: '-n', file: '+n', piece: self)
      ]
    end

    def to_s
      @side == :white ? "\u2657" : "\u265D"
    end
  end
end

