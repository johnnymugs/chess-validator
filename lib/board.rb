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
    piece_position = nil

    @pieces.each { |k,v| piece_position = Position.new(k) if v == piece }
    raise RuntimeError.new("Piece not found on board") unless piece_position

    legal_moves = []

    piece.basic_moves.each do |move|
      if move.takes_steps?
        step = 1
        while((next_move = move.from_position(piece_position, step: step)) && is_within_bounds?(next_move))
          legal_moves << next_move
          step += 1
        end
      else
        next_move = move.from_position(piece_position)
        legal_moves << next_move if is_within_bounds?(next_move)
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
end

