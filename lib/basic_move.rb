class BasicMove
  ASCII_OFFSET = 96

  attr_reader :rank, :file

  def initialize(rank: nil, file: nil)
    @rank = rank || 0
    @file = file || 0
  end

  def +(position)
    Position.new(file: @file + position.file, rank: @rank + position.rank) unless takes_steps?
  end

  def from_position(position, step: 1)
    Position.new(file: n_to_move(@file, step) + position.file, rank: n_to_move(@rank, step) + position.rank)
  end

  def takes_steps?
    @takes_steps ||= @rank == '+n' ||
                   @rank == '-n' ||
                   @file == '+n' ||
                   @file == '-n'
  end

  private

  def n_to_move(move, step)
    return move == "-n" ? -1 * step :
           move == "+n" ? +1 * step :
           move
  end

  def file_as_notation(file)
    (file + ASCII_OFFSET).chr
  end
end

