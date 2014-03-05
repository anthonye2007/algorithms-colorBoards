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
    rows = [1, 0, 0]
    cols = [1, 0, 0]
    greedy(rows, cols)
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

    puts "Failed" if not board.isValid?
    puts board.to_s
end

class Board
    def initialize(rows, cols)
        @rows = rows
        @cols = cols
        @length = rows.length
        @numTokens = 0

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
        @numTokens += 1
    end
    def numTokens
        return @numTokens
    end
    def isValid?
        (0..@length - 1).each do |row|
            numTokensExpected = @rows[row]
            sum = 0

            (0..@length - 1).each do |col|
                sum += 1 if @board[[row,col]]
            end

            return false if sum != numTokensExpected
        end

        (0..@length - 1).each do |col|
            numTokensExpected = @cols[col]
            sum = 0

            (0..length - 1).each do |row|
                sum += 1 if @board[[row,col]]
            end

            return false if sum != numTokensExpected
        end

        return true
    end
    def to_s
        str = ""

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
