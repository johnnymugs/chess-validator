shared_examples_for "a piece" do
  it "should have a single character representation" do
    expect(described_class.new.to_s.size).to equal(1)
  end

  it "should have a set of basic moves" do
    expect(described_class.new.basic_moves.size).to be > 0
  end

  describe "#moved?" do
    subject { piece.moved? }
    let(:piece) { described_class.new }

    context "with a new piece" do
      it { should be_falsy }
    end

    context "with a moved piece" do
      before { piece.move! }

      it { should be_truthy }
    end
  end
end

