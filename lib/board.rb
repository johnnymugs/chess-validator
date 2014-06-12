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

  def legal_moves_for_piece(piece, at_position:nil)
    piece_position = at_position || position_for_piece(piece)

    legal_moves = []
    piece.basic_moves.each do |move|
      step = 1
      loop do
        next_move = move.from_position(piece_position, step: step)
        break unless is_within_bounds?(next_move) && can_occupy_position?(piece, next_move)
        legal_moves << next_move
        break if piece_at(next_move)
        break unless move.takes_steps?
        step += 1
      end
    end

    legal_moves
  end

  def legal_moves_for(side)
    @pieces
    .select { |position, piece| piece.side == side }
    .map { |position, piece| legal_moves_for_piece(piece, at_position: Position.new(position)) }
    .flatten
  end

  def print
    BoardPrinter.new(self).print
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

  def position_for_piece(piece)
    position = nil
    @pieces.each { |k,v| position = Position.new(k) if v == piece }
    position || raise(RuntimeError.new("Piece not found on board"))
  end

  def can_occupy_position?(piece, move)
    !piece_at(move.to_s) ||
      (move.requires_capture? && piece_at(move.to_s).side != piece.side) ||
      (move.can_capture? && piece_at(move.to_s).side != piece.side)
  end
end

