class Pawn < Piece
  def basic_moves
    [
      BasicMove.new(rank: +1, file: 0),
      BasicMove.new(rank: +1, file: +1, requires_capture: true),
      BasicMove.new(rank: +1, file: -1, requires_capture: true)
    ]
  end

  def to_s
    @side == :white ? "\u2659" : "\u265F"
  end
end

