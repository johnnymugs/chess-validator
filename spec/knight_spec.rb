require 'spec_helper'

describe Knight do
  it_should_behave_like "a piece"

  describe "#basic_moves" do
    subject { Knight.new.basic_moves.map { |move| move.from_position(current_position) }.map(&:to_s) }

    context "from f3" do
      let(:current_position) { Position.new("f3") }

      it "contains the potential moves" do
        expect(subject).to match_array(%w{ g1 e1 d2 d4 h2 h4 g5 e5 })
      end
    end
  end
end

