require 'spec_helper'

describe BasicMove do
  let(:piece) { Pawn.new }

  describe "#rank" do
    subject { BasicMove.new(rank: rank, piece: piece).rank }

    context "when rank is specified" do
      let(:rank) { 1 }
      it { should == rank }
    end

    context "when rank is not specified" do
      let(:rank) { nil }
      it { should == 0 }
    end
  end

  describe "#file" do
    subject { BasicMove.new(file: file, piece: piece).file }

    context "when file is specified" do
      let(:file) { 1 }
      it { should == file }
    end

    context "when file is not specified" do
      let(:file) { nil }
      it { should == 0 }
    end
  end

  describe "#from_position" do
    let(:position) { Position.new("d4") }

    context "with steps specified" do
      subject { move.from_position(position, step: step).to_s }
      let(:step) { 2 }

      context "when the move takes steps on the rank" do
        let(:move) { BasicMove.new(rank: "+n", file: 0, piece: piece) }

        it { should == "d6" }
      end

      context "when the move takes backward steps on the rank" do
        let(:move) { BasicMove.new(rank: "-n", file: 0, piece: piece) }

        it { should == "d2" }
      end

      context "when the move takes steps on the file" do
        let(:move) { BasicMove.new(rank: 0, file: "+n", piece: piece) }

        it { should == "f4" }
      end

      context "when the move takes backwards steps on the file" do
        let(:move) { BasicMove.new(rank: 0, file: "-n", piece: piece) }

        it { should == "b4" }
      end

      context "when the move does not take steps" do
        let(:move) { BasicMove.new(rank: 1, file: 0, piece: piece) }

        it "should quietly ignore the step" do
          expect(subject).to eq("d5")
        end
      end
    end

    context "without steps specified" do
      subject { move.from_position(position).to_s }

      context "when the move does not take steps" do
        let(:move) { BasicMove.new(rank: 1, file: 0, piece: piece) }

        it { should == "d5" }
      end

      context "when the move takes steps" do
        let(:move) { BasicMove.new(rank: "+n", file: 0, piece: piece) }

        it "should silently just use one step" do
          expect(subject).to eq("d5")
        end
      end
    end
  end

  describe "#takes_steps?" do
    subject { move.takes_steps? }
    context "when the move takes steps on the rank" do
      let(:move) { BasicMove.new(rank: "+n", file: 0, piece: piece) }

      it { should be_truthy }
    end

    context "when the move takes backward steps on the rank" do
      let(:move) { BasicMove.new(rank: "-n", file: 0, piece: piece) }

      it { should be_truthy }
    end

    context "when the move takes steps on the file" do
      let(:move) { BasicMove.new(rank: 0, file: "+n", piece: piece) }

      it { should be_truthy }
    end

    context "when the move takes backwards steps on the file" do
      let(:move) { BasicMove.new(rank: 0, file: "-n", piece: piece) }

      it { should be_truthy }
    end

    context "when the move does not take steps" do
      let(:move) { BasicMove.new(rank: 1, file: 0, piece: piece) }

      it { should be_falsy }
    end
  end
end

