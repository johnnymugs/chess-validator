require 'spec_helper'

describe Position do
  describe "#initialize" do
    context "with a position given in notation" do
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

    context "with rank and file coordinates given" do
      it "doesn't throw an error" do
        expect { Position.new(file: 1, rank: 1) }.to_not raise_error
      end

      it "sets rank and file values" do
        expect(Position.new(file: 3, rank: 1).file).to eq(3)
        expect(Position.new(file: 1, rank: 2).rank).to eq(2)
      end
    end

    context "with neither rank and file coordinates or notational coordinates given" do
      it "throws an error" do
        expect { Position.new }.to raise_error
      end
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

  describe "#to_s" do
    subject { Position.new(rank: rank, file: file).to_s }

    context "with rank and file in range" do
      let(:rank) { 8 }
      let(:file) { 2 }

      it { should == "b8" }
    end

    context "with rank out of range" do
      let(:rank) { 9 }
      let(:file) { 2 }

      it { should == "(╯°□°)╯︵ ┻━┻ (position is off the board)" }
    end

    context "with file out of range" do
      let(:rank) { 7 }
      let(:file) { -1 }

      it { should == "(╯°□°)╯︵ ┻━┻ (position is off the board)" }
    end
  end
end

