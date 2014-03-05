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
    rows = [1, 1, 2]
    cols = [1, 2, 1]
    greedy(rows, cols)
end

def greedy(rows, cols)
    puts "Rows: " + rows.to_s
    puts "Columns: " + cols.to_s

    board = Board.new(rows, cols)

    rows.each_with_index do |row|
        cols.each_with_index do |col|
            while row > 0 && col > 0
                board.add(row, col)
                row -= 1
                col -= 1
            end 
        end
    end
end

class Board
    def initialize(rows, cols)
        @rows = rows
        @cols = cols
        @length = rows.length

        @board = Hash.new(@length * @length)

        (0..@length).each do |row|
            (0..@length).each do |col|
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
    def to_s
    end
end

driver
