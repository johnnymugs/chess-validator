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

  def legal_moves_for(piece)
    position = nil
    @pieces.each { |k,v| position = Position.new(k) if v == piece }
    raise RuntimeError.new("Piece not found on board") unless position
    piece.basic_moves
      .map { |move| move + position }
      .select { |position| is_within_bounds?(position) }
  end

  private

  def is_within_bounds?(position)
    (1..8).include?(position.rank) && (1..8).include?(position.file)
  end

  def is_valid_position?(position)
    file = position[0] # a...h
    rank = position[1] # 1...8
    ('a'..'h').include?(file.downcase) && ('1'..'8').include?(rank)
  end
end

