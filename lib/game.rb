module CV
  class Game
    attr_reader :board, :turn

    def self.load_from_moves(moves)
      game = self.new(default: true)
      MoveParser.new(moves).parse do |move|
        game.move!(move)
      end
      game
    end

    def initialize(default: false)
      @turn = :white
      @board = Board.new

      set_up_default_board if default
    end

    def move!(move_in_notation)
      if move = find_move_by_notation(move_in_notation)
        @turn = next_turn
        @board.move!(move.origin, move.dest)
        @legal_moves = nil
      else
        raise RuntimeError.new("Invalid move! (#{move_in_notation})")
      end
    end

    def can_move?(move)
      legal_moves.map(&:to_notation).include?(move)
    end

    def ambiguous_move_matches_for(move)
      legal_moves
      .select { |legal_move| move[-2..-1] == legal_move.to_s }
      .map(&:to_notation)
    end

    def check?
      board.possible_moves_for(next_turn).include?(board.king_position(turn))
    end

    def legal_moves
      @legal_moves ||= calculate_legal_moves
    end

    def checkmate?
      check? && !legal_moves.any?
    end

    def stalemate?
      !(check? || legal_moves.any?)
    end

    private

    def calculate_legal_moves
      moves = board.possible_moves_for(turn)
      .select do |move|
        tempboard = @board.dupe
        tempboard.move!(move.origin, move.dest)
        !tempboard.possible_moves_for(next_turn).include?(tempboard.king_position(turn))
      end

      assign_notation(moves)
      clarify_ambiguity(moves)
    end


    def assign_notation(moves)
      moves.each do |move|
        capture = board.piece_at(move.dest) ? true : false
        piece_notation = (capture && move.piece.is_a?(Pawn)) ? move.origin[0] : move.piece.to_notation
        move.notation =
          piece_notation +
          (capture ? 'x' : '') +
          move.dest
      end
    end

    def clarify_ambiguity(moves)
      moves.each do |move|
        dupes = moves.select { |other_move| other_move.to_notation == move.to_notation }
        case dupes.size
        when 1
          # no dupes, do nothing
        when 2
          if dupes.first.origin[0] != dupes.last.origin[0] # compare file
            dupes.first.notation = move.piece.to_notation + dupes.first.origin[0] + (board.piece_at(move.dest).nil? ? '' : 'x') + move.dest
            dupes.last.notation = move.piece.to_notation + dupes.last.origin[0] + (board.piece_at(move.dest).nil? ? '' : 'x') + move.dest
          else # use rank to disambiguate
            dupes.first.notation = move.piece.to_notation + dupes.first.origin[1] + (board.piece_at(move.dest).nil? ? '' : 'x') + move.dest
            dupes.last.notation = move.piece.to_notation + dupes.last.origin[1] + (board.piece_at(move.dest).nil? ? '' : 'x') + move.dest
          end
        else # 3 or more ambiguous pieces, this can only happen with rare multiple pawn promotion (!!!)
          dupes.each do |move|
            move.notation = move.piece.to_notation +
              move.origin +
              (board.piece_at(move.dest).nil? ? '' : 'x') +
              move.dest
          end
        end
      end
    end

    def next_turn
      @turn == :white ? :black : :white
    end

    def find_move_by_notation(move_in_notation)
      legal_moves.detect { |move| move.to_notation == move_in_notation }
    end

    def set_up_default_board
      @board.add(piece: Rook.new, at: 'a1')
      @board.add(piece: Knight.new, at: 'b1')
      @board.add(piece: Bishop.new, at: 'c1')
      @board.add(piece: Queen.new, at: 'd1')
      @board.add(piece: King.new, at: 'e1')
      @board.add(piece: Bishop.new, at: 'f1')
      @board.add(piece: Knight.new, at: 'g1')
      @board.add(piece: Rook.new, at: 'h1')

      @board.add(piece: Pawn.new, at: 'a2')
      @board.add(piece: Pawn.new, at: 'b2')
      @board.add(piece: Pawn.new, at: 'c2')
      @board.add(piece: Pawn.new, at: 'd2')
      @board.add(piece: Pawn.new, at: 'e2')
      @board.add(piece: Pawn.new, at: 'f2')
      @board.add(piece: Pawn.new, at: 'g2')
      @board.add(piece: Pawn.new, at: 'h2')

      @board.add(piece: Rook.new(side: :black), at: 'a8')
      @board.add(piece: Knight.new(side: :black), at: 'b8')
      @board.add(piece: Bishop.new(side: :black), at: 'c8')
      @board.add(piece: Queen.new(side: :black), at: 'd8')
      @board.add(piece: King.new(side: :black), at: 'e8')
      @board.add(piece: Bishop.new(side: :black), at: 'f8')
      @board.add(piece: Knight.new(side: :black), at: 'g8')
      @board.add(piece: Rook.new(side: :black), at: 'h8')

      @board.add(piece: Pawn.new(side: :black), at: 'a7')
      @board.add(piece: Pawn.new(side: :black), at: 'b7')
      @board.add(piece: Pawn.new(side: :black), at: 'c7')
      @board.add(piece: Pawn.new(side: :black), at: 'd7')
      @board.add(piece: Pawn.new(side: :black), at: 'e7')
      @board.add(piece: Pawn.new(side: :black), at: 'f7')
      @board.add(piece: Pawn.new(side: :black), at: 'g7')
      @board.add(piece: Pawn.new(side: :black), at: 'h7')
    end
  end
end

