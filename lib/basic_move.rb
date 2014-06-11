class BasicMove
  ASCII_OFFSET = 96

  attr_reader :rank, :file

  def initialize(rank: nil, file: nil, requires_capture: false)
    @rank = rank || 0
    @file = file || 0
    @requires_capture = requires_capture
  end

  def from_position(position, step: 1)
    LegitMove.new(file: n_to_move(@file, step) + position.file,
                  rank: n_to_move(@rank, step) + position.rank,
                  requires_capture: @requires_capture)
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

