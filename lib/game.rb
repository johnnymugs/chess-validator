module CV
  class Game
    attr_reader :board, :turn
    attr_accessor :previous_move

    def self.load_from_moves(moves)
      game = self.new(default: true)
      MoveParser.new(moves).parse do |move|
        game.move!(move)
      end
      game
    end

    def self.load_from_json(json)
      game = self.new(turn: json[:turn])
      json[:pieces].each do |piece|
        obj_piece = Object.const_get(piece[:type]).new(side: piece[:side].to_sym, moved: piece[:moved])
        game.board.add(piece: obj_piece, at: piece[:position])
      end
      game
    end

    def initialize(default: false, turn: :white)
      @turn = turn
      @board = Board.new

      set_up_default_board if default
    end

    def to_json
      {
        turn: @turn,
        pieces: @board.pieces.map do |position, piece|
          {
            type: piece.class.to_s,
            side: piece.side.to_s,
            moved: piece.moved?,
            position: position.to_s
          }
        end
      }
    end

    def move!(move_in_notation)
      if move = find_move_by_notation(move_in_notation)
        @board.move!(move.origin, move.dest)

        # castle
        if second_move = move.secondary_move
          @board.move!(second_move.origin, second_move.dest)
        end

        # pawn promotion
        if promoted_piece = move.promote_to
          @board.swap_piece_at(move.dest, with: move.promote_to)
        end

        @turn = next_turn
        @legal_moves = nil
        @previous_move = build_previous_move(move)
      else
        raise RuntimeError.new("Invalid move! (#{move_in_notation})")
      end
    end

    def legal_move?(move)
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
      moves = board.possible_moves_for(turn) + legal_castling_moves
      moves = filter_moves_that_result_in_check(moves)
      assign_notation(moves)
      clarify_ambiguity(moves)

      adjust_for_pawn_promotion(moves)
    end

    def filter_moves_that_result_in_check(moves)
      moves.select do |move|
        tempboard = @board.dupe
        tempboard.move!(move.origin, move.dest)
        if second_move = move.secondary_move # castling
          tempboard.move!(second_move.origin, second_move.dest)
        end
        !tempboard.possible_moves_for(next_turn).include?(tempboard.king_position(turn))
      end
    end

    ### Castling ###
    def legal_castling_moves
      return [] if check?
      return [] if king_moved?
      castle_moves = []
      castle_moves << queenside_castle if castlable_queenside_rook? && path_clear_for_queenside_castle?
      castle_moves << kingside_castle if castlable_kingside_rook? && path_clear_for_kingside_castle?
      castle_moves
    end

    def king_moved?
      (king = board.piece_at(board.king_position(turn))) && king.moved?
    end

    def castlable_queenside_rook?
      (rook = board.piece_at("a#{backrank}")) &&
        rook.to_notation == "R" &&
        !rook.moved?
    end

    def castlable_kingside_rook?
      (rook = board.piece_at("h#{backrank}")) &&
        rook.to_notation == "R" &&
        !rook.moved?
    end

    def path_clear_for_queenside_castle?
      !(
        board.piece_at("b#{backrank}") ||
        board.piece_at("c#{backrank}") ||
        board.piece_at("d#{backrank}")
      )
    end

    def path_clear_for_kingside_castle?
      !(
        board.piece_at("f#{backrank}") ||
        board.piece_at("g#{backrank}")
      )
    end

    def backrank
      turn == :white ? 1 : 8
    end

    def queenside_castle
      rook_move = PossibleMove.new(rank: backrank, file: 4, can_capture: false, origin: "a#{backrank}", piece: board.piece_at("a#{backrank}"))
      PossibleMove.new(rank: backrank, file: 3, can_capture: false, origin: "e#{backrank}", piece: board.piece_at("e#{backrank}"), notation: 'O-O-O', secondary_move: rook_move)
    end

    def kingside_castle
      rook_move = PossibleMove.new(rank: backrank, file: 6, can_capture: false, origin: "h#{backrank}", piece: board.piece_at("a#{backrank}"))
      PossibleMove.new(rank: backrank, file: 7, can_capture: false, origin: "e#{backrank}", piece: board.piece_at("e#{backrank}"), notation: 'O-O', secondary_move: rook_move)
    end

    ### /castling ###

    ### Pawn promotion ###

    def adjust_for_pawn_promotion(moves)
      promo_backrank = turn == :white ? '8' : '1'
      promo_moves = moves.select { |move| move.piece.is_a?(Pawn) && move.dest[1] == promo_backrank }

      moves -= promo_moves
      promo_moves.each do |move|
        [ Queen, Bishop, Knight, Rook ].each do |possible_promotion|
          moves << promotion_move(basic_move: move, promote_to: possible_promotion.new(side: turn, moved: true))
        end
      end
      moves
    end

    def promotion_move(basic_move:, promote_to:)
      PossibleMove.new(
        promote_to: promote_to,
        notation: basic_move.to_notation + promote_to.to_notation,
        rank: basic_move.rank,
        file: basic_move.file,
        can_capture: basic_move.can_capture?,
        requires_capture: basic_move.requires_capture?,
        origin: basic_move.origin,
        piece: board.piece_at(basic_move.origin)
      )
    end

    ### /pawn promotion ###

    def assign_notation(moves)
      moves.each do |move|
        return move if move.notation
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

    def build_previous_move(move)
      {
        origin: move.origin,
        dest: move.dest,
        in_notation: move.to_notation
      }
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

