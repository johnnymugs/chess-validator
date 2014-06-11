class Piece
  attr_reader :side

  def initialize(side: :white)
    raise ArgumentError unless [:white, :black].include?(side)
    @side = side
  end

  def basic_moves
    raise NotImplementedError
  end

  def to_s
    raise NotImplementedError
  end
end

