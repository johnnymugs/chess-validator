class LegitMove < Position
  def initialize(rank:, file:, requires_capture: false, can_capture: true, piece:)
    @requires_capture = requires_capture
    @can_capture = can_capture
    @piece = piece
    super(rank: rank, file: file)
  end

  def requires_capture?
    @requires_capture
  end

  def can_capture?
    @can_capture
  end
end

