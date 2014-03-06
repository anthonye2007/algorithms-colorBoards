Anthony Elliott
University of Northern Iowa
CS 3530 Algorithms
Dr. Wallingford
Homework 3
3/4/2014

To run:
  ./colorBoards.rb <sizeOfBoard> <timesToRun>
  where 'sizeOfBoard' is a number like 3
  and 'timesToRun' is a number like 1000

Design:
I created a Position class to keep the relation between a value and an index into the original array.
Without this I had an awful time trying to map a sorted array back to the original array after making modifications.
I also created a Board class which helped to pass things around.

Hardest part:
Backtracking was really hard.


Tasks 1: Greedy
Examples (get this output by passing in '-g' as an argument)

Rows: [1, 1]
Cols: [1, 1]
X-
-X

Rows: [1, 1, 2]
Cols: [1, 2, 1]
X--
-X-
-XX

Rows: [1, 1, 3]
Cols: [1, 1, 3]
Failed

Rows: [1, 3, 1]
Cols: [2, 2, 1]
X--
XXX
-X-

Rows: [1, 2, 3, 2]
Cols: [2, 3, 2, 1]
X---
XX--
-XXX
-XX-

Rows: [1, 2, 3, 2]
Cols: [2, 3, 3, 0]
Failed


Task 2: Zoomin
Examples  (get this output by passing in '-z' as an argument)

Rows: [1, 1]
Cols: [1, 1]
X-
-X

Rows: [1, 1, 2]
Cols: [1, 2, 1]
-X-
-X-
X-X

Rows: [1, 3, 1]
Cols: [2, 2, 1]
X--
XXX
-X-

Rows: [1, 1, 3]
Cols: [1, 1, 3]
--X
--X
XXX

Rows: [1, 2, 3, 2]
Cols: [2, 3, 2, 1]
-X--
XX--
XXX-
--XX

Rows: [1, 2, 3, 2]
Cols: [2, 3, 3, 0]
-X--
-XX-
XXX-
X-X-


Task 4
Running 1000 times with size 3
Number illegal colorings: 103
Average time for zoomin: 6.9895e-05 seconds
Number of greedy fails: 260
Average time for greedy success: 0.00022229615384615386 seconds
Average time for greedy failure: 7.810405405405406e-05 seconds

Task 5
Running 1000 times with size 10
Number illegal colorings: 413
Average time for zoomin: 0.001132047 seconds
Number of greedy fails: 974
Average time for greedy success: 0.000587152977412731 seconds
Average time for greedy failure: 0.02199565384615385 seconds

Task 6
This did not finish within 20 minutes even when I just ran 1 time with a size of 1000
Do this via
  ./colorBoards.rb 1000 1
  