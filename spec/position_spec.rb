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

  describe "#==" do
    subject { position1 == position2 }
    let(:position1) { Position.new("a1") }

    context "when two positions are on the same rank and file" do
      let(:position2) { Position.new("a1") }
      it { should be_truthy }
    end

    context "when two positions are on different ranks" do
      let(:position2) { Position.new("a2") }
      it { should be_falsy }
    end

    context "when two positions are on different files" do
      let(:position2) { Position.new("b1") }
      it { should be_falsy }
    end
  end
end

