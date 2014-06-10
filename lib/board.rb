class Board
  attr_reader :pieces

  def initialize
    @pieces = {}
  end

  def piece_at(position)
    @pieces[position]
  end

  def add(piece:, at:)
    raise RuntimeError.new("#{at} is not a valid position") unless is_valid_position?(at)
    raise RuntimeError.new("There is already a piece at #{at}") unless @pieces[at].nil?

    @pieces[at] = piece
  end

  private

  def is_valid_position?(position)
    file = position[0] # a...h
    rank = position[1] # 1...8
    ('a'..'h').include?(file.downcase) && ('1'..'8').include?(rank)
  end
end

