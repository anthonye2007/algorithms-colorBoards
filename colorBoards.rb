#!/usr/bin/ruby
####################
# Anthony Elliott
# University of Northern Iowa
# CS 3530 Algorithms
# Dr. Wallingford
# Homework 3
# 3/4/2014
####################

def driver (should_log)
    rows = [2, 1, 1]
    cols = [1, 2, 1]
    greedy2(rows, cols, should_log)
end

def bubble_sort(list)
  return list if list.size <= 1 # already sorted
  swapped = true
  while swapped do
    swapped = false
    0.upto(list.size-2) do |i|
      if list[i].value < list[i+1].value
        list[i], list[i+1] = list[i+1], list[i] # swap values
        swapped = true
      end
    end
  end

  list
end

def zoomin(rows, cols, should_log)
  logger = Logger.new(should_log)

  board = Board.new(rows, cols)

  # make deep copies to avoid modifying the original references in board
  new_rows = rows.clone
  new_cols = cols.clone
  puts 'Row: ' + new_rows.to_s
  puts 'Col: ' + new_cols.to_s

  columns = []
  new_cols.each_with_index do |value, index|
    if value > new_rows.length
      return
    end
    pos = Position.new(index, value)
    columns.push(pos)
  end

  # sort columns
  sorted_cols = bubble_sort(columns)

  new_rows.each_with_index do |row_value, row_index|
    num_cols_remaining = row_value
    next if num_cols_remaining == 0

    already_added = []
    while sorted_cols.first.value > 0 && num_cols_remaining > 0
      log_positions(sorted_cols, should_log)
      position_to_add = get_position(sorted_cols.clone, already_added)

      logger.log 'Adding at [' + row_index.to_s + ', ' + position_to_add.index.to_s + ']'
      board.add(row_index, position_to_add.index)
      already_added.push(position_to_add.index)

      position_to_add.decrement
      sorted_cols = bubble_sort(sorted_cols)
      num_cols_remaining -= 1
    end
  end

  puts board.to_s
end

def log_positions (positions, should_log)
  logger = Logger.new(should_log)
  positions.each do |i|
    logger.log 'value: ' + i.value.to_s + "\tindex: " + i.index.to_s
  end
end

# Return index of first empty spot in positions
# Assume positions is sorted with highest value in first position
def get_position(positions, already_added)
  if already_added.include?(positions.first.index)
    positions.shift
    return get_position(positions, already_added)
  end

  positions.first
end

def greedy(rows, cols)
    board = Board.new(rows, cols)

    rows.each_with_index do |num_in_row, i|
        cols.each_with_index do |num_in_col, j|
            while num_in_row > 0 && num_in_col > 0
                board.add(i, j)
                num_in_row -= 1
                num_in_col -= 1
            end 
        end
    end

    puts board.to_s
end

def greedy2(rows, cols, should_log)
    board = Board.new(rows, cols)

    # make deep copies to avoid modifying the original references
    new_rows = rows.clone
    new_cols = cols.clone
    puts 'Row: ' + rows.to_s
    puts 'Col: ' + cols.to_s
    place_at_highest_intersection(board, new_rows, new_cols, should_log)
end

def place_at_highest_intersection(board, rows, cols, should_log)
    if rows.max <= 0 or cols.max <= 0
        puts board.to_s
        return
    end

    # pick highest row then highest col and place x there
    max_row_index = rows.index(rows.max)
    max_col_index = cols.index(cols.max)

    if board.occupied?(max_row_index, max_col_index)
        # try keeping the row steady and reduce the column
        max_col_index = find_unoccupied_col(board, max_row_index, cols, max_col_index)

        # if still occupied after reaching either all columns or column value of 0 
        # then reset column to original value and do the same process with the rows
        if max_col_index.nil?
            max_col_index = cols.index(cols.max)
            max_row_index = find_unoccupied_col(board, max_col_index, rows, max_row_index)

            # fail if go through all rows or reach row of zero value
            abort('Could not backtrack') if max_row_index.nil? || rows[max_row_index] == 0
        end
    end
    logger = Logger.new(should_log)
    logger.log 'Adding at [' + max_row_index.to_s + ', ' + max_col_index.to_s + ']'

    rows[max_row_index] -= 1
    cols[max_col_index] -= 1

    board.add(max_row_index, max_col_index)

    place_at_highest_intersection(board, rows, cols, should_log)
end

def find_unoccupied_col(board, row_index, cols, already_tried)
    # remember these are not the originals

    sorted_cols = cols.clone.sort
    # we previously tried sortedCols.last and it didn't work, so get rid of it
    sorted_cols.pop

    # map max of sortedCols back to cols
    max_val = sorted_cols.last
    indicies_of_same_value = []
    cols.each_with_index do |col, i|
        indicies_of_same_value.push(i) if col == max_val && already_tried != i
    end

    # pick the highest index not yet tried
    indicies_of_same_value.each do |col|
      return col unless board.occupied?(row_index, col)
    end

    # fail if reach here
    nil
end
   
class Board
    def initialize(rows, cols)
        @rows = rows
        @cols = cols
        @length = rows.length

        @board = Hash.new(@length)

        (0..@length - 1).each do |row|
            (0..@length - 1).each do |col|
                @board[[row,col]] = false
            end
        end
    end
    def length
        @length
    end
    def add(row, col)
        @board[[row,col]] = true
    end
    def rows
        @rows
    end
    def cols
        @cols
    end
    def occupied?(row, col)
        @board[[row,col]]
    end
    def is_valid?
        (0..@length - 1).each do |row|
            num_tokens_expected = @rows[row]
            sum = 0

            (0..@length - 1).each do |col|
                sum += 1 if @board[[row,col]]
            end

            if sum != num_tokens_expected
                puts 'Failed on row ' + row.to_s + ': expected ' + num_tokens_expected.to_s + ' tokens but got ' + sum.to_s
                return false 
            end
        end

        (0..@length - 1).each do |col|
            num_tokens_expected = @cols[col]
            sum = 0

            (0..length - 1).each do |row|
                sum += 1 if @board[[row,col]]
            end

            if sum != num_tokens_expected
                puts 'Failed on col ' + col.to_s + ': expected ' + num_tokens_expected.to_s + ' tokens but got ' + sum.to_s
                return false 
            end
        end

        true
    end
    def to_s
        str = ''
        is_valid?
        #str += "Failed\n" unless is_valid?

        (0..@length - 1).each do |row|
            (0..@length - 1).each do |col|
                if @board[[row,col]]
                    str += 'X'
                else
                    str += '-'
                end
            end
            str += "\n"
        end

        str
    end
end

class Logger
    @should_log = false
    def initialize(on)
      @should_log = on
    end
    def log (msg)
      puts msg if @should_log
    end
end

class Position
  def initialize(index, value)
    @index = index
    @value = value
  end
  def index
    @index
  end
  def value
    @value
  end
  def decrement
    @value -= 1
  end
end

def testGreedy2 (should_log)
    rows = [1,1]
    cols = [1,1]
    greedy2(rows, cols, should_log)
    puts

    rows = [1,1,2]
    cols = [1,2,1]
    greedy2(rows, cols, should_log)
    puts

    rows = [1,3,1]
    cols = [2,2,1]
    greedy2(rows, cols, should_log)
    puts

    rows = [1,2,3,2]
    cols = [2,3,2,1]
    greedy2(rows, cols, should_log)
    puts

    rows = [1,2,3,2]
    cols = [2,3,3,0]
    greedy2(rows, cols, should_log)

end

def test_zoomin (should_log)
  rows = [1,1]
  cols = [1,1]
  zoomin(rows, cols, should_log)
  puts

  rows = [1,1,2]
  cols = [1,2,1]
  zoomin(rows, cols, should_log)
  puts

  rows = [1,3,1]
  cols = [2,2,1]
  zoomin(rows, cols, should_log)
  puts

  rows = [1,2,3,2]
  cols = [2,3,2,1]
  zoomin(rows, cols, should_log)
  puts

  rows = [1,2,3,2]
  cols = [2,3,3,0]
  zoomin(rows, cols, should_log)
end

def easy_zoomin_test(should_log)
  rows = [1,0]
  cols = [0,1]
  zoomin(rows, cols, should_log)

  rows = [2,1]
  cols = [2,1]
  zoomin(rows, cols, should_log)
end


should_log = ARGV.include?('-v')
#testGreedy2(should_log)

#easy_zoomin_test(should_log)
test_zoomin(should_log)

=begin
columns = []
columns.push(Position.new(0,10))
columns.push(Position.new(1,5))
columns.push(Position.new(2, 8))

sorted = bubble_sort(columns)
sorted.each do |i|
  puts 'value: ' + i.value.to_s + "\tindex: " + i.index.to_s
end
=end
