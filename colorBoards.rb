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

    rows.each_with_index do |numInRow, i|
        cols.each_with_index do |numInCol, j|
            while numInRow > 0 && numInCol > 0
                board.add(i, j)
                numInRow -= 1
                numInCol -= 1
            end 
        end
    end

    puts board.to_s
end

def greedy2(rows, cols)
    board = Board.new(rows, cols)

    # make deep copies to avoid modifiying the original references
    newRows = rows.clone
    newCols = cols.clone
    puts "Row: " + rows.to_s
    puts "Col: " + cols.to_s
    placeAtHighestIntersection(board, newRows, newCols)
end

def placeAtHighestIntersection(board, rows, cols)
    if rows.max <= 0 or cols.max <= 0
        puts board.to_s
        return
    end

    # pick highest row then highest col and place x there
    maxRowIndex = rows.index(rows.max)
    maxColIndex = cols.index(cols.max)

    if (board.occupied?(maxRowIndex, maxColIndex))
        # try keeping the row steady and reduce the column
        colsTried = [maxColIndex]
        maxColIndex = findUnoccupiedCol(board, rows, cols, colsTried)

        # if still occupied after reaching either all columns or column value of 0 
        # then reset column to original value and do the same process with the rows
        if (maxColIndex.nil?)
            maxColIndex = cols.index(cols.max)
            rowsTried = [maxRowIndex]
            maxRowIndex = findUnoccupiedCol(board, cols, rows, rowsTried)

            # fail if go through all rows or reach row of zero value
            return nil if maxRowIndex.nil? || rows[maxRowIndex] == 0
        end
    end

    puts "Row: " + maxRowIndex.to_s + "\tCol: " + maxColIndex.to_s 

    rows[maxRowIndex] -= 1
    cols[maxColIndex] -= 1

    board.add(maxRowIndex, maxColIndex)

    return placeAtHighestIntersection(board, rows, cols)
end

def findUnoccupiedCol(board, rowIndex, cols, alreadyTried)
    # remember these are not the originals

    sortedCols = cols.clone.sort
    # we previously tried sortedCols.last and it didn't work, so get rid of it
    sortedCols.pop

    # map max of sortedCols back to cols
    maxVal = sortedCols.last
    indicesOfSameValues = []
    cols.each_with_index do |col, i|
        indicesOfSameValues.push(i) if col == maxVal && !alreadyTried.include?(i)
    end

    # pick the highest index not yet tried
    indicesOfSameValues.each do |col|
        return col if !board.occupied?(rowIndex, col)
    end

    # fail if reach here
    return nil
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
        return @length
    end
    def add(row, col)
        @board[[row,col]] = true
    end
    def rows
        return @rows
    end
    def cols
        return @cols
    end
    def occupied?(row, col)
        return @board[[row,col]]
    end
    def isValid?
        (0..@length - 1).each do |row|
            numTokensExpected = @rows[row]
            sum = 0

            (0..@length - 1).each do |col|
                sum += 1 if @board[[row,col]]
            end

            if sum != numTokensExpected
                puts "Failed on row " + row.to_s + ": expected " + numTokensExpected.to_s + " tokens but got " + sum.to_s
                return false 
            end
        end

        (0..@length - 1).each do |col|
            numTokensExpected = @cols[col]
            sum = 0

            (0..length - 1).each do |row|
                sum += 1 if @board[[row,col]]
            end

            if sum != numTokensExpected
                puts "Failed on col " + col.to_s + ": expected " + numTokensExpected.to_s + " tokens but got " + sum.to_s
                return false 
            end
        end

        return true
    end
    def to_s
        str = ""

        str += "Failed\n" if not isValid?

        (0..@length - 1).each do |row|
            (0..@length - 1).each do |col|
                if @board[[row,col]]
                    str += "X"
                else
                    str += "-"
                end
            end
            str += "\n"
        end

        return str
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

if (ARGV.include?('-t'))
    tests
else
    tests
end
