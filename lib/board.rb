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
    piece_position = position_for_piece(piece)

    legal_moves = []
    piece.basic_moves.each do |move|
      step = 1
      loop do
        next_move = move.from_position(piece_position, step: step)
        break unless is_within_bounds?(next_move) && !piece_at(next_move.to_s)
        legal_moves << next_move
        break unless move.takes_steps?
        step += 1
      end
    end

    legal_moves
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
    @pieces.map{ |k,v| Position.new(k) if v == piece }.first || raise(RuntimeError.new("Piece not found on board"))
  end
end

