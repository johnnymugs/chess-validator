module CV
  class PossibleMove < Position
    attr_accessor :notation, :secondary_move
    attr_reader :piece

    def initialize(rank:, file:, requires_capture: false, can_capture: true, piece:, origin:, notation: nil, secondary_move: nil)
      @requires_capture = requires_capture
      @can_capture = can_capture
      @piece = piece
      @origin = origin
      @notation = notation
      @secondary_move = secondary_move # for castling
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

