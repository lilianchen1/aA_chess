# Chess

Chess game at the end of day 2 (2 day project).

This is a game run in the console.

To run the game:

1. run `gem install colorize`
2. run `ruby chess_game.rb`

### Starting Board
![alt text][start_board]
[start_board]: ./chessgamess/startingboard.png


### Selecting a player will highlight all valid destinations on the board
![alt text][highlight]
[highlight]: ./chessgamess/highlightmoves.png

#### design logic

Chess is broken down into a Game class, a Board class, and Piece(s) class. Each chess piece (King, Queen, Knight, etc.) is its own class
and inherit from either Stepping Piece or Sliding Piece. Stepping Piece and Sliding Piece
inherit are subclasses of the superclass Piece.

Game class includes logic of the game (play loop, check if game is over, prompt players to select move/destination).

Board class has the board logic (rendering board, move pieces, check if king is in check).
To check whether a move will put the king in check, the board is deep duped and each
valid move tested (make a move, check to see if any of the opponent's move can then win the game). Game is over when all valid moves would lead to checkmate.
Piece class has the logic of pieces (move directions, valid moves).

Pieces are created on a board instance in the Board class at appropriate positions and board passes itself to the piece. Game is initialized with a new Board, and a starting player.

A errors are raised and handled by Begin/Rescue block to ensure players enter valid moves (coordinate pairs).
