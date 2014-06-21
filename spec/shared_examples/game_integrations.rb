shared_examples_for "a valid game" do
  it "should run the game as expected" do
    expect(game.board.to_s).to eq(expected_output)

  # it should be able to serialze to and from JSON
    expect(Game.load_from_json(game.to_json).board.to_s).to eq(expected_output)

  # it should include turn and previous move information
    expect(Game.load_from_json(game.to_json).turn).to eq(game.turn)
    expect(Game.load_from_json(game.to_json).previous_move).to eq(game.previous_move)
  end
end

