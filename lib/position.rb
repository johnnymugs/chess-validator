class Position
  ASCII_OFFSET = 96

  attr_reader :rank, :file

  def initialize(position_in_notation = nil, rank: nil, file: nil)
    raise ArgumentError unless position_in_notation || rank && file
    if position_in_notation
      @file = file_to_coord(position_in_notation[0])
      @rank = position_in_notation[1].to_i

      raise ArgumentError unless valid_rank_and_file?
    else
      @file = file
      @rank = rank
    end
  end

  def ==(other_position)
    @file == other_position.file && @rank == other_position.rank
  end

  def to_s
    return "(╯°□°)╯︵ ┻━┻ (position is off the board)" unless valid_rank_and_file?
    file_as_notation + @rank.to_s
  end

  private

  def file_to_coord(file)
    file.downcase.ord - ASCII_OFFSET
  end

  def file_as_notation
    (@file + ASCII_OFFSET).chr
  end

  def valid_rank_and_file?
    (1..8).include?(@rank) && (1..8).include?(@file)
  end
end

