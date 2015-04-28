require 'byebug'

class Piece
  attr_accessor :pos, :board
  attr_reader :color

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  def enemy?(pos)
    return false if @board[pos].nil?
    @color != @board[pos].color
  end

  def valid?(pos, king_check = true)
    return false if !pos.all? { |x| x.between?(0, @board.length - 1)}
    if !@board[pos].nil?
      return false if @board[pos].color == @color
    end
    return !king_in_check?(pos) if king_check == true
    true
  end

  def king_in_check?(end_pos)
    dup_board = @board.dup
    dup_board.move(@pos, end_pos)
    dup_board.check?(@color)
  end

end

class SlidingPiece < Piece
  def moves(king_check_flag = true)

    possible_moves = []

    move_dirs.each do |pair|
      x = @pos[0]
      y = @pos[1]
      found_enemy = false
      while valid?([x + pair[0], y + pair[1]], king_check_flag) && !found_enemy
        x += pair[0]
        y += pair[1]
        possible_moves << [x, y]
        found_enemy = enemy?([x, y])
      end
    end
    possible_moves
  end
end

class Bishop < SlidingPiece
  def move_dirs
    [[-1, 1], [-1, -1], [1, 1], [1, -1]]
  end

  def render_piece
    return '♝'.colorize(:color => :black) if @color == :black
    "♝".colorize(:color => :white) if @color == :white
  end
end

class Rook < SlidingPiece
  def move_dirs
    [[0, 1], [0, -1], [1, 0], [-1, 0]]
  end

  def render_piece
    return '♜'.colorize(:color => :black) if @color == :black
    "♜".colorize(:color => :white) if @color == :white
  end
end

class Queen < SlidingPiece
  def move_dirs
    directions = [1, 0, -1].repeated_permutation(2).to_a.reject {|pos| pos == [0, 0]}
  end

  def render_piece
    return '♛'.colorize(:color => :black) if @color == :black
    "♛".colorize(:color => :white) if @color == :white
  end
end

class SteppingPiece < Piece
  def moves(king_check_flag = true)
    possible_moves = []
    x = @pos[0]
    y = @pos[1]
    move_dirs.each do |pair|
      if valid?([x + pair[0], y + pair[1]], king_check_flag)
        possible_moves << [x + pair[0], y + pair[1]]
      end
    end
    possible_moves
  end
end

class King < SteppingPiece
  def move_dirs
    directions = [1, 0, -1].repeated_permutation(2).to_a.reject {|pos| pos == [0, 0]}
  end

  def render_piece
    return '♚'.colorize(:color => :black) if @color == :black
    "♚".colorize(:color => :white) if @color == :white
  end
end

class Knight < SteppingPiece
  def move_dirs
    [[-1, 2], [1, 2], [2, 1], [2, -1], [-2, 1], [-2, -1], [1, -2], [-1, -2]]
  end

  def render_piece
    return '♞'.colorize(:color => :black) if @color == :black
    "♞".colorize(:color => :white) if @color == :white
  end
end

class Pawn < SteppingPiece
  attr_reader :first_move

  def initialize(pos, color, board)
    super(pos, color, board)
    @first_move = false
  end

  def diagonal_dirs
    if @color == :black
      return [[1, -1], [1, 1]]
    else
      return [[-1, -1], [-1, 1]]
    end
  end

  def enemy_diagonal
    diagonal_positions = []
    diagonal_dirs.each do |coord|
      diagonal_pos = [coord[0] + @pos[0], coord[1] + @pos[1]]
      if enemy?(diagonal_pos)
        diagonal_positions << coord
      end
    end
    return diagonal_positions
  end

  def piece_in_front?
    if @color == :black
      front = [@pos[0] + 1, @pos[1]]
      return false if @board[front].nil?
      true
    else
      front = [@pos[0] - 1, @pos[1]]
      return false if @board[front].nil?
      true
    end
  end

  def move_dirs
    if @first_move == false && !piece_in_front?
      return [[1, 0], [2, 0]].concat(enemy_diagonal) if @color == :black
      return [[-1, 0], [-2, 0]].concat(enemy_diagonal)
    elsif @first_move == true && !piece_in_front?
      return [[1, 0]].concat(enemy_diagonal) if @color == :black
      return [[-1, 0]].concat(enemy_diagonal)
    elsif piece_in_front?
      return enemy_diagonal
    end
  end

  def first_move
    @first_move = true
  end

  def render_piece
    return '♟'.colorize(:color => :black) if @color == :black
    "♟".colorize(:color => :white) if @color == :white
  end
end
