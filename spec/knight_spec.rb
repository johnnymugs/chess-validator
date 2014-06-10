require 'spec_helper'

describe Knight do
  describe "#possible_moves" do
    subject { Knight.new.possible_moves.map { |move| move + current_position } }

    context "from f3" do
      let(:current_position) { Position.new("f3") }

      it "contains the potential moves" do
        expect(subject).to match_array([ 'g1', 'e1', 'd2', 'd4', 'h2', 'h4', 'g5', 'e5' ])
      end
    end
  end
end

