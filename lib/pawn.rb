class Pawn < Piece
  def basic_moves
    moves = [
      BasicMove.new(rank: +1, file: 0, can_capture: false),
      BasicMove.new(rank: +1, file: +1, requires_capture: true),
      BasicMove.new(rank: +1, file: -1, requires_capture: true)
    ]
    moves << BasicMove.new(rank: +2, file: 0, can_capture: false) if !moved?
    moves
  end

  def to_s
    @side == :white ? "\u2659" : "\u265F"
  end
end

