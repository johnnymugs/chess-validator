module CV
  class PossibleMove < Position
    attr_accessor :notation
    attr_reader :piece, :secondary_move, :promote_to

    def initialize(rank:, file:, requires_capture: false, can_capture: true, piece:, origin:, notation: nil, secondary_move: nil, promote_to: nil)
      @requires_capture = requires_capture
      @can_capture = can_capture
      @piece = piece
      @origin = origin
      @notation = notation
      @secondary_move = secondary_move # for castling
      @promote_to = promote_to
      super(rank: rank, file: file)
    end

    def dest
      to_s
    end

    def origin
      @origin.to_s
    end

    def requires_capture?
      @requires_capture
    end

    def can_capture?
      @can_capture
    end

    def to_notation
      @notation
    end
  end
end

