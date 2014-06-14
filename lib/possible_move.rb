module CV
  class PossibleMove < Position
    attr_accessor :notation
    attr_reader :piece

    def initialize(rank:, file:, requires_capture: false, can_capture: true, piece:, origin:)
      @requires_capture = requires_capture
      @can_capture = can_capture
      @piece = piece
      @origin = origin
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

