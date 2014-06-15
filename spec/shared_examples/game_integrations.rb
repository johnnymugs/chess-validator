shared_examples_for "a valid game" do
  it "should run the game as expected" do
    expect(game.board.to_s).to eq(expected_output)
  end
end

shared_examples_for "a serializable game" do
  it "should be able to serialze to and from JSON" do
    expect(Game.load_from_json(game.to_json).board.to_s).to eq(expected_output)
  end

  it "should include turn information" do
    expect(Game.load_from_json(game.to_json).turn).to eq(game.turn)
  end
end

