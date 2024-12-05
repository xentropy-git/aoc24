# Day 1

I took two approaches to day 1.  The first attempt was a naive attempt
to solve the problem as simple as I could with minimal optimization.  I added
a hashmap for part 2 to memoize the frequency counts, but that's about it.

The second approach was to learn about SIMD vectorization.  The results are
below:

NAIVE:
--------------------------------------------------------------------------------
Benchmark results
--------------------------------------------------------------------------------
name , met (ms)    , iters   
Part1,     3.604825,       33
Part2,     2.346645,       50


SIMD Optimized:
--------------------------------------------------------------------------------
Benchmark results
--------------------------------------------------------------------------------
name , met (ms)    , iters   
Part1,     1.780815,       66
Part2,     2.022368,       60


SIMD operations reduced the cpu cost by about 50% for part 1 and about 14%
for part 2.  I couldn't figure out how to do vectorization with memoization,
so I'm uncertain if it is possible.  We might need a thread safe hashmap
type to do that.
