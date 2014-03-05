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
    #greedy(rows, cols)
    #puts ""
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

    #puts "Row: " + maxRowIndex.to_s + "\tCol: " + maxColIndex.to_s 

    rows[maxRowIndex] -= 1
    cols[maxColIndex] -= 1

    board.add(maxRowIndex, maxColIndex)

    return placeAtHighestIntersection(board, rows, cols)
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

driver
