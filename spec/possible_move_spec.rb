require 'spec_helper'

describe PossibleMove do
  describe "#rank" do
    subject { PossibleMove.new(rank: rank).rank }

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
    subject { PossibleMove.new(file: file).file }

    context "when file is specified" do
      let(:file) { 1 }
      it { should == file }
    end

    context "when file is not specified" do
      let(:file) { nil }
      it { should == 0 }
    end
  end

  describe "#+" do
    subject { PossibleMove.new(rank: rank, file: file) + current_position }

    context "with a positive value for rank" do
      let(:rank) { 1 }
      let(:file) { 0 }
      let(:current_position) { Position.new("a1") }

      it { should == "a2" }
    end
  end
end
