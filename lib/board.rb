module CV
  class Board
    attr_reader :pieces

    def initialize
      @pieces = {}
    end

    def dupe
      new_board = Board.new
      @pieces.each do |position, piece|
        new_board.add(piece: piece.dupe, at: position)
      end
      new_board
    end

    def piece_at(position)
      @pieces[position.to_s]
    end

    def move!(origin, dest)
      raise RuntimeError.new("Nothing at #{ origin }") if @pieces[origin].nil?
      @pieces[dest] = @pieces.delete(origin)
      @pieces[dest].move!
    end

    def add(piece:, at:)
      raise RuntimeError.new("#{at} is not a valid position") unless is_valid_position?(at)
      raise RuntimeError.new("There is already a piece at #{at}") unless @pieces[at].nil?

      @pieces[at] = piece
    end

    def swap_piece_at(dest, with:)
      raise RuntimeError.new("#{dest} is not a valid position") unless is_valid_position?(dest)
      @pieces[dest] = with
    end

    def possible_moves_for_piece(piece, at_position:nil)
      piece_position = at_position || position_for_piece(piece)

      possible_moves = []
      piece.basic_moves.each do |move|
        step = 1
        loop do
          next_move = move.from_position(piece_position, step: step)
          break unless is_within_bounds?(next_move) && can_occupy_position?(piece, next_move)
          possible_moves << next_move
          break if piece_at(next_move)
          break unless (move.takes_steps? && step < move.max_steps)
          step += 1
        end
      end

      possible_moves
    end

    def possible_moves_for(side)
      @pieces
      .select { |position, piece| piece.side == side }
      .map { |position, piece| possible_moves_for_piece(piece, at_position: Position.new(position)) }
      .flatten
    end

    def king_position(side)
      if position = @pieces
        .detect { |position, piece| piece.side == side && piece.to_notation == King.new.to_notation }
        Position.new(position.first) # detect returns an array of key (position) and val (piece)
      end
    end

    def to_s
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
      if other_piece = piece_at(move.to_s)
        move.can_capture? && other_piece.side != piece.side
      else
        !move.requires_capture?
      end
    end
  end
end

