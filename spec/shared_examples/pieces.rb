shared_examples_for "a piece" do
  it "should have a single character representation" do
    expect(described_class.new.to_s.size).to equal(1)
  end

  it "should have a notation representation" do # empty string in the case of pawns
    expect { described_class.new.to_notation }.to_not raise_error
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

  describe "#dupe" do
    subject { piece.dupe }
    let(:piece) { described_class.new }

    it "makes a copy of the piece" do
      expect(subject).to_not equal(piece)
    end

    context "when the piece has been moved" do
      before { piece.move! }

      it { should be_moved }
    end

    context "when the piece has not been moved" do
      before { expect(piece.moved?).to be_falsy }

      it { should_not be_moved} # http://i.imgur.com/ja2wX.jpg
    end

    context "with a white piece" do
      it "sets the duped piece's side to white" do
        expect(subject.side).to eq(:white)
      end
    end

    context "with a black piece" do
      let(:piece) { described_class.new(side: :black) }

      it "sets the duped piece's side to black" do
        expect(subject.side).to eq(:black)
      end
    end
  end
end

