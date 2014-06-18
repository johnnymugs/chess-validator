- Pawn promotion
- Pawn en passant
- Pawn movement isn't unit tested properly, relies too heavily on integration specs
- board#calculate_possible_moves assumes a king piece exists -> this keeps biting me in the ass!
- Lots of the API is tedious, especially unnecessary keyword arguments and move/rank conversion

