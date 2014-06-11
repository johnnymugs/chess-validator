require 'spec_helper'

describe Pawn do
  it_should_behave_like "a piece"

  describe "#basic_moves" do
    subject { pawn.basic_moves.map { |move| move.from_position(current_position) }.map(&:to_s) }
    let(:pawn) { Pawn.new }
    let(:current_position) { Position.new("a2") }

    context "when the pawn has not moved" do
      it "can move ahead two spaces" do
        expect(subject).to include("a4")
      end
    end

    context "when the pawn has moved" do
      before { pawn.move! }
      it "cannot move ahead two spaces" do
        expect(subject).to_not include("a4")
      end
    end
  end
end

