class MoveParser
  attr_accessor :moves

  def initialize(unparsed_moves)
    @unparsed_moves = unparsed_moves
    @moves = []
  end

  def parse
    i = 0
    while (i < @unparsed_moves.size) do
      # read move number, either one or two digits (eg '1. ', '23. ')
      raise ArgumentError unless ('1'..'9').include?(@unparsed_moves[i])
      i += 1
      i += ('1'..'9').include?(@unparsed_moves[i]) ? 3 : 2

      # read white move
      move = ""
      while (@unparsed_moves[i] != ' ' && i < @unparsed_moves.size) do
        move << @unparsed_moves[i]
        i += 1
      end
      @moves << move
      yield(move) if block_given?

      # read black move, if played
      if i < @unparsed_moves.size
        move = ""
        i += 1
        while (@unparsed_moves[i] != ' ' && i < @unparsed_moves.size) do
          move << @unparsed_moves[i]
          i += 1
        end
        @moves << move
        yield(move) if block_given?
      end

      i += 1
    end

    @moves
  end
end

