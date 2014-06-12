class Game
  attr_reader :turn

  def initialize
    @turn = :white
  end

  def move
    @turn = @turn == :white ? :black : :white
  end
end

