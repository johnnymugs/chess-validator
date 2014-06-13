require 'spec_helper'

describe MoveParser do
  describe '#parse!' do
    subject { -> { parser.parse { |move| parsed_moves << move } } }
    let(:parser) { MoveParser.new(input) }
    let(:parsed_moves) { [] }

    context "with well-formed input" do
      let(:input) { '1. e4 e5 2. Nf3 Nc6 3. Bb5' }
      it { should change { parsed_moves }.to(['e4','e5', 'Nf3', 'Nc6', 'Bb5']) }
      it { should change { parser.moves }.to(['e4','e5', 'Nf3', 'Nc6', 'Bb5']) }

      it "should return the parsed moves" do
        expect(subject.call).to eq(['e4','e5', 'Nf3', 'Nc6', 'Bb5'])
      end
    end

    context "with well-formed double digit input" do
      let(:input) { '10. e4 e5 11. Nf3 Nc6 12. Bb5' }
      it { should change { parsed_moves }.to(['e4','e5', 'Nf3', 'Nc6', 'Bb5']) }
      it { should change { parser.moves }.to(['e4','e5', 'Nf3', 'Nc6', 'Bb5']) }

      it "should return the parsed moves" do
        expect(subject.call).to eq(['e4','e5', 'Nf3', 'Nc6', 'Bb5'])
      end
    end

    context "without proper numbers" do
      let(:input) { 'a. e7' }
      it { should raise_error }
    end
      let(:input) { 'fhqwghads'}
    context "with nonsense" do
      let(:input) { 'fhqwghads' }
      it { should raise_error }
    end
  end
end

