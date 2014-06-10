require 'spec_helper'

describe Position do
  describe "#initialize" do
    subject { -> { Position.new(position_in_notation) } }

    context "with a valid position" do
      let(:position_in_notation) { "h1" }

      it { should_not raise_error }

      it "should set rank and file as numbered coordinates" do
        position = subject.call
        expect(position.file).to eq(8)
        expect(position.rank).to eq(1)
      end
    end

    context "with an out of range file" do
      let(:position_in_notation) { "i1" }
      it { should raise_error }
    end

    context "with an out of range rank" do
      let(:position_in_notation) { "a9" }
      it { should raise_error }
    end
  end
end

