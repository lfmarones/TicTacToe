require_relative 'player'

class Game

  attr_accessor :current_player, :next_player
  attr_reader :players

  def initialize(players)
    @players = players
    @grid = Array.new(3) { Array.new(3, '-') }
    @current_player = players[0]
    @next_player = players[1]
    @expanded_grid = expand_grid
  end

  # Creates an array with all rows, all columns and all diagonals in order to verify winning sequences
  def expand_grid
    new_grid = []
    new_grid = @grid + @grid.transpose
    primary_diagonal = []
    @grid.each_with_index { |x, idx| x.each_with_index { |y, idy| primary_diagonal << y if idx == idy } }
    new_grid << primary_diagonal
    secondary_diagonal = []
    @grid.each_with_index { |x, idx| x.each_with_index { |y, idy| secondary_diagonal << y if idx + idy == 2 } }
    new_grid << secondary_diagonal
  end

  def reset_grid
    @grid = Array.new(3) { Array.new(3, '-') }
  end

  def set_mark(mark:, row:, column:)
    @grid[row][column] = mark
    @expanded_grid = expand_grid
  end

  def random_play
    row = 0
    column = 0
    loop do
      row = rand(0..2)
      column = rand(0..2)
      break if @grid[row][column] == "-"
    end
    set_mark(mark:@current_player.mark, row:row, column:column)
  end

  def is_available?(row:, column:)
    @grid[row][column] == "-" ? true : false
  end

  def count_available_positions
    count = 0
    @grid.each { |row| count += row.count("-") }
    count
  end

  def count_winning_sequences
    count = 0
    @expanded_grid.each { |line| count += 1 if line.all?(@current_player.mark) }
    count
  end

  def print_grid
    puts
    puts '  0   1   2'
    @grid.each_with_index { |line, index| puts index.to_s + ' ' + line.join(' | ') }
    puts
  end

  def show_players
    @players.each { |player| player.to_string }
  end
end
