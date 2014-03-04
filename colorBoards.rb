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
end

driver
