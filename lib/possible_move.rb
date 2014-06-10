class PossibleMove
  ASCII_OFFSET = 96

  attr_reader :rank, :file

  def initialize(rank: nil, file: nil)
    @rank = rank || 0
    @file = file || 0
  end

  def +(position)
    file_as_notation(@file + position.file) + (@rank + position.rank).to_s
  end

  private

  def file_as_notation(file)
    (file + ASCII_OFFSET).chr
  end
end

