class Piece
  attr_reader :side

  def initialize(side: :white, moved: false)
    raise ArgumentError unless [:white, :black].include?(side)
    @side = side
    @moved = moved
  end

  def basic_moves
    raise NotImplementedError
  end

  def to_s
    raise NotImplementedError
  end

  def move!
    @moved = true
  end

  def moved?
    @moved
  end
end

