class LegitMove < Position
  def initialize(rank:, file:, requires_capture: false, can_capture: true)
    @requires_capture = requires_capture
    @can_capture = can_capture
    super(rank: rank, file: file)
  end

  def requires_capture?
    @requires_capture
  end

  def can_capture?
    @can_capture
  end
end

