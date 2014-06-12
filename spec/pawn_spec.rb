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

    context "when the pawn is white" do
      let(:pawn) { Pawn.new(side: :white) }
      let(:current_position) { Position.new('b2') }
      it { should match_array(%w{ b3 b4 a3 c3 }) }
    end

    context "when the pawn is black" do
      let(:pawn) { Pawn.new(side: :black) }
      let(:current_position) { Position.new('b7') }

      it { should match_array(%w{ b6 b5 a6 c6 }) }
    end
  end
end

