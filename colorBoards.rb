#!/usr/bin/ruby
####################
# Anthony Elliott
# University of Northern Iowa
# CS 3530 Algorithms
# Dr. Wallingford
# Homework 3
# 3/4/2014
####################

def driver
    rows = [2, 1, 1]
    cols = [1, 2, 1]
    greedy2(rows, cols)
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

def greedy2(rows, cols)
    board = Board.new(rows, cols)

    # make deep copies to avoid modifying the original references
    new_rows = rows.clone
    new_cols = cols.clone
    puts 'Row: ' + rows.to_s
    puts 'Col: ' + cols.to_s
    place_at_highest_intersection(board, new_rows, new_cols)
end

def place_at_highest_intersection(board, rows, cols)
    if rows.max <= 0 or cols.max <= 0
        puts board.to_s
        return
    end

    # pick highest row then highest col and place x there
    max_row_index = rows.index(rows.max)
    max_col_index = cols.index(cols.max)

    if board.occupied?(max_row_index, max_col_index)
        # try keeping the row steady and reduce the column
        max_col_index = find_unoccupied_col(board, rows, cols, max_col_index)

        # if still occupied after reaching either all columns or column value of 0 
        # then reset column to original value and do the same process with the rows
        if max_col_index.nil?
            max_col_index = cols.index(cols.max)
            max_row_index = find_unoccupied_col(board, cols, rows, max_row_index)

            # fail if go through all rows or reach row of zero value
            abort('Could not backtrack') if max_row_index.nil? || rows[max_row_index] == 0
        end
    end

    puts 'Row: ' + max_row_index.to_s + "\tCol: " + max_col_index.to_s

    rows[max_row_index] -= 1
    cols[max_col_index] -= 1

    board.add(max_row_index, max_col_index)

    place_at_highest_intersection(board, rows, cols)
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

        str += "Failed\n" unless is_valid?

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

def tests
    rows = [1,1]
    cols = [1,1]
    greedy2(rows, cols)
    puts

    rows = [1,1,2]
    cols = [1,2,1]
    greedy2(rows, cols)
    puts

    rows = [1,3,1]
    cols = [2,2,1]
    greedy2(rows, cols)
    puts

    rows = [1,2,3,2]
    cols = [2,3,2,1]
    greedy2(rows, cols)
    puts

    rows = [1,2,3,2]
    cols = [2,3,3,0]
    greedy2(rows, cols)

end

tests
