# Chess engine
# Amol Dharmadhikari <adharma@cs.usfca.edu>

module Const
  WHITE_MOVE = 0
  BLACK_MOVE = 1

  NO_PIECE = 0x00000000
  PAWN = 0x00000001
  BISHOP = 0x00000010
  KNIGHT = 0x00000100
  ROOK = 0x00001000
  QUEEN = 0x00010000
  KING = 0x00100000
  WHITE_MASK = 0x00000000
  BLACK_MASK = 0x10000000
  MAX_BIT_MASK = 0x01111111
end

# class Piece
class Piece
  attr_accessor :piece

  # Initialize the piece based on color and piece information passed
  def initialize(color='', piece='')
    @piece = Const::NO_PIECE
    
    if color === 'white'
      @piece |= Const::WHITE_MASK
    elsif color === 'black'
      @piece |= Const::BLACK_MASK
    end

    if piece === 'pawn'
      @piece |= Const::PAWN
    elsif piece === 'bishop'
      @piece |= Const::BISHOP
    elsif piece === 'knight'
      @piece |= Const::KNIGHT
    elsif piece === 'rook'
      @piece |= Const::ROOK
    elsif piece === 'queen'
      @piece |= Const::QUEEN
    else piece === 'king'
      @piece |= Const::KING

  end

    def white?
      return not (@piece & Const::WHITE_MASK)
    end

    def black?
      return (@piece & Const::WHITE_MASK)
    end

    def to_s
      # Return a string representation of the piece. 
      # By default, white pieces are represented by capital letters and
      # black pieces by small letters
      # Convention:
      #	    Rook -> r, R
      #	    Bishop -> b, B
      #	    Knight -> n, N
      #	    King -> k, K
      #	    Queen -> q, Q
      #	    Pawn -> p, P
      str = ''

      if @piece & Const::MAX_BIT_MASK & Const::PAWN
        str = 'p'
      elsif @piece & Const::MAX_BIT_MASK & Const::BISHOP
        str = 'b'
      elsif @piece & Const::MAX_BIT_MASK & Const::KNIGHT
        str = 'n'
      elsif @piece & Const::MAX_BIT_MASK & Const::ROOK
        str = 'r'
      elsif @piece & Const::MAX_BIT_MASK & Const::QUEEN
        str = 'q'
      elsif @piece & Const::MAX_BIT_MASK & Const::KING
        str = 'k'
      elsif @piece == Const::NO_PIECE
        str = '.'
      end

      if @piece & Const::BLACK_MASK
        return str
      elsif not(@piece & Const::WHITE_MASK)
        return str.upcase
      else
        return str
    end
    
end

class Pos

# Pieces
BLACK_PAWN = Piece('black', 'pawn')
BLACK_BISHOP = Piece('black', 'bishop')
BLACK_KNIGHT = Piece('black', 'knight')
BLACK_ROOK = Piece('black', 'rook')
BLACK_QUEEN= Piece('black', 'queen')
BLACK_KING = Piece('black', 'king')
WHITE_PAWN = Piece('white', 'pawn')
WHITE_BISHOP = Piece('white', 'bishop')
WHITE_KNIGHT = Piece('white', 'knight')
WHITE_ROOK = Piece('white', 'rook')
WHITE_QUEEN= Piece('white', 'queen')
WHITE_KING = Piece('white', 'king')

# class Pos
class Pos:
    def __init__(self, pos=''):
        self.pos = pos
        self.rank = pos[0]
        self.fil = pos[1]

        self.y = 8 - int(self.fil) 
        self.x = ord(self.rank) - ord('a')

    def __str__(self):
	return 'x = ' + str(self.x) + ' y = ' + str(self.y)

# Exception IllegalMoveException
class IllegalMoveException(Exception):
    def __init__(self, msg=None):
        Exception.__init__(self, msg)

# class Move
class Move:
    def __init__(self, fromPosStr='', toPosStr=''):
	# fromPos and toPos are in algebraic notation
	self.fromPosStr = fromPosStr
	self.toPosStr = toPosStr
	
	self.fromPos = None
	self.toPos = None

	if (self.fromPosStr):
	    self.fromPos = Pos(self.fromPosStr)
	if (self.toPosStr):
	    self.toPos = Pos(self.toPosStr)

# class Board
class Board:
    FILES = 'abcdefgh'

    def __init__(self, b=None):
        self.bitmap = [0, 0, 0, 0, 0, 0, 0, 0]
        
        # Normal constructor
        if not b:
            self.board = []

            # Create a blank board
            for i in range(8):
                # Create a blank rank
                rank = []
                for j in range(8):
                    rank.append(None)
                    
                self.board.append(rank)

        # Copy constructor
        else:
            self.board = []

            # Create a blank board
            for i in range(8):
                rank = []
                brank = b[i]
                for j in range(8):
                    piece = brank[j]
                    if piece.piece() != Piece.NO_PIECE:
                        self.bitmap[j] = self.bitmap[j] | (1 << j)
                    rank.append(piece)

                self.board.append(rank)            

    # Set the starting position on the board
    def setStartingPosition(self):
	# black rooks
        self.setAt(Pos('a8'), BLACK_ROOK)
        self.setAt(Pos('h8'), BLACK_ROOK)

	# white rooks
        self.setAt(Pos('a1'), WHITE_ROOK)
        self.setAt(Pos('h1'), WHITE_ROOK)

	# black knights
        self.setAt(Pos('b8'), BLACK_KNIGHT)
        self.setAt(Pos('g8'), BLACK_KNIGHT)

	# white knights
        self.setAt(Pos('b1'), WHITE_KNIGHT)
        self.setAt(Pos('g1'), WHITE_KNIGHT)

	# black bishops
	self.setAt(Pos('c8'), BLACK_BISHOP) 
	self.setAt(Pos('f8'), BLACK_BISHOP)

	# white bishops
	self.setAt(Pos('c1'), WHITE_BISHOP) 
	self.setAt(Pos('f1'), WHITE_BISHOP)

	# black king and queen
	self.setAt(Pos('d8'), BLACK_QUEEN)
	self.setAt(Pos('e8'), BLACK_KING)

	# white king and queen
	self.setAt(Pos('d1'), WHITE_QUEEN)
	self.setAt(Pos('e1'), WHITE_KING)

	# black and white pawns
	for i in range(8):
	    pos1 = Pos(self.FILES[i] + '7')
	    pos2 = Pos(self.FILES[i] + '2')
	    self.setAt(pos1, BLACK_PAWN) 
	    self.setAt(pos2, WHITE_PAWN)


    # Set the piece at the given position on this board
    def setAt(self, pos, piece):
        self.board[pos.y][pos.x] = piece

    # Return a string representation of the board
    def __str__(self):
        s = ''
        for i in range(len(self.board)):
            rank = self.board[i]
            for j in range(len(rank)):
                piece = rank[j]
                if piece:
                    s = s + str(piece) + ' '
                else:
                    s = s + '. '
            s = s + '\n'

	# Remove the last '\n' and return the string
        return string.strip(s)

    def isCheckMate(self):
	pass

    def isLegalDraw(self):
	pass

    def isStaleMate(self):
	pass

    # Return a list of all legal moves, that 
    def getAllLegalMoves(self, whoseMove):
        moveLst = []

        moveLst.append(self.pawnMoves)
        moveLst.append(self.bishopMoves)
        moveLst.append(self.knightMoves)
        moveLst.append(self.rookMoves)
        moveLst.append(self.queenMoves)
        moveLst.append(self.kingMoves)

        return moveLst

    def newPosition(self, whoseMove, move):
        pass

    def pawnMoves(self):
        lst = []

        # First get all pawn positions
        
        return lst


    def bishopMoves(self):
        pass

    def knightMoves(self):
        pass

    def rookMoves(self):
        pass

    def queenMoves(self):
        pass

    def kingMoves(self):
        pass

    # Returns true/false based on whether the position on the board is empty.
    # pos -> Pos object
    def isEmptySquare(self, pos):
        pass
    
# Interface for Player classes
class AbstractPlayer:
    def __init__(self, name):
	self.name = name

    # This method will return a move
    # whoseMove -> 'white' or 'black'
    # board -> the Board object
    def getMove(self, board, whoseMove):
	pass

    # Returns true/false depending on whether the move is legal or not
    # in the context of the board and whoseMove
    def isLegal(self, board, whoseMove):
	pass

    def getName(self):
	return self.name

# class HumanPlayer
class HumanPlayer(AbstractPlayer):
    def __init__(self):
	AbstractPlayer.__init__(self, 'HUMAN')
    
    # Read the move from the console, perform error checking i.e. 
    # ensure that the move made is that of the color who is supposed
    # to make it and is a legal move and return it. 
    def getMove(self, board, whoseMove):
	ret = raw_input('Enter move: ')
	while 1:
	    if self.isLegal(ret, board, whoseMove):
		break
	    ret = raw_input('Enter move: ')

	return ret

    # Check whether the move is legal in the context of the board
    # and whoseMove
    # Returning true for now
    def isLegal(self, move, board, whoseMove):
	return 1

    def getName(self):
	return AbstractPlayer.getName(self)

# class MachinePlayer
class MachinePlayer(AbstractPlayer):
    def __init__(self):
	AbstractPlayer.__init__(self, 'MACHINE')
    
    # Make the move based on computations for the MachinePlayer
    def getMove(self, board, whoseMove):
	return self.getRandomLegalMove(board, whoseMove)

    # No need for this method here since its the computer's move. 
    # So simply returning true
    def isLegal(self, board, whoseMove):
	return 1

    def getName(self):
	return AbstractPlayer.getName(self)

    def getRandomLegalMove(self, board, whoseMove):
	pass

# class ChessEngine
class ChessEngine:
    PROMPT1 = 'White Player: Human/Machine: '  
    PROMPT2 = 'Black Player: Human/Machine: ' 
    PLAYERS = ['H', 'M', 'h', 'm']
    HUMANS = ['H', 'h']
    MACHINES = ['M', 'm']

    def __init__(self):
	# Get an instance of the board
	self.b = Board()
	self.b.setStartingPosition()

	# The white and black players
	self.whitePlayer = None
	self.blackPlayer = None

        # Whose move
        self.whoseMove = WHITE_MOVE

        # The current move
        self.move = ''

    # Init game parameters
    def initGameParameters(self):
	ret1 = raw_input(self.PROMPT1)
	while 1:
	    if ret1 in self.PLAYERS:
		break
	    ret1 = raw_input(self.PROMPT1)

	ret2 = raw_input(self.PROMPT2)
	while 1:
	    if ret2 in self.PLAYERS:
		break
	    ret2 = raw_input(self.PROMPT2)

	self.setPlayers(ret1, ret2)

    def setPlayers(self, white, black):
	if white in self.HUMANS:
	    self.whitePlayer = HumanPlayer()
	elif white in self.MACHINES:
	    self.whitePlayer = MachinePlayer()

	if black in self.HUMANS:
	    self.blackPlayer = HumanPlayer()
	elif black in self.MACHINES:
	    self.blackPlayer = MachinePlayer()

    # Print the board
    def printBoard(self):
	print "White: ", self.whitePlayer.getName()
	print str(self.b)
	print "Black: ", self.blackPlayer.getName()

    # Main loop in which the game is played
    def play(self):
	while 1:
            self.printBoard()

            try:
                # Get the move from the player whose move it is. Start with
                # white and then alternate
                move = ''
                if self.whoseMove == WHITE_MOVE:
                    move = self.whitePlayer.getMove(self.b, self.whoseMove)
                elif self.whoseMove == BLACK_MOVE:
                    move = self.blackPlayer.getMove(self.b, self.whoseMove)

                # Get new position of the board based on the move
                self.b.newPosition(whoseMove, move)

                # Change whoseMove
                self.whoseMove ^= 1
                
            except IllegalMoveException, e:
                print "Illegal move! Try again"

# Main method
def main(argv):
    chessEngine = ChessEngine()
    chessEngine.initGameParameters()
    chessEngine.play()
    sys.exit(0)

# Entry point	
if __name__ == '__main__':
    main(sys.argv)
