from collections import Dict
from benchmark import *
from algorithm import map, map_reduce, parallelize

# amd ryzen 9000 has 512 bit wide simd registers.
# it looks like we need at least int32 to fit the data in the input
# chunk size of 16 is appropriate.
alias chunk_size = 16
alias dtype = DType.int32

fn main() raises:
    print("AOC24 - Day 1")
    var input = read_input()

    var answer1 = part1(input)
    var answer2 = part2(input)
    print("The answer to part 1 is ", str(answer1))
    print("The answer to part 2 is ", str(answer2))

    var bench_cfg = BenchConfig()
    bench_cfg.tabular_view = True

    var m = Bench(bench_cfg)
    m.bench_with_input[String, benchmark_part1](BenchId("Part1"), input)
    m.bench_with_input[String, benchmark_part2](BenchId("Part2"), input)
    m.dump_report()

fn read_input() raises -> String:
    with open("../../../input/1.txt", "r") as f:
        return f.read()

@parameter
@always_inline
fn benchmark_part1(inout b: Bencher, s: String):
    @always_inline
    @parameter
    fn do() raises:
        _ = part1(s)
    try:
        b.iter[do]()
    except:
        pass
    _ = s

@parameter
@always_inline
fn benchmark_part2(inout b: Bencher, s: String):
    @always_inline
    @parameter
    fn do() raises:
        _ = part2(s)
    try:
        b.iter[do]()
    except:
        pass
    _ = s

    
fn part1(input: String) -> Int:
    var lines = input.splitlines()
    var left = List[Scalar[dtype]]()
    var right = List[Scalar[dtype]]()
    left.append(0)
    right.append(0)
    
    for i in range(len(lines)):
        try:
            var cols = lines[i].split("  ")
            left.append(int(cols[0]))
            right.append(int(cols[1]))
        except:
            pass

    var end_pad = len(lines) % chunk_size
    for _ in range(end_pad):
        left.append(0)
        right.append(0)
    sort(left)
    sort(right)
    var acc = 0
    var elements = len(left)

    for i in range((elements // chunk_size) + 1):
        var l = left.data.offset(i * chunk_size).load[dtype, chunk_size]()
        var r = right.data.offset(i * chunk_size).load[dtype, chunk_size]()
        acc += int(abs(r - l).reduce_add())

    return acc

fn fast_freq_count(left: SIMD[dtype, 1024], right: SIMD[dtype, 1024], inout freq: SIMD[dtype, 1024]):
    @parameter
    fn count(i: Int):
        var f =  (right == left[i]).select[dtype](1,0).reduce_add()
        freq[i] = f

    parallelize[count](1024)

fn part2(input: String) raises -> Int:
    var lines = input.splitlines()
    var l_data = SIMD[dtype, 1024]()
    var r_data = SIMD[dtype, 1024]()
    for i in range(len(lines)):
        var cols = lines[i].split("  ")
        l_data[i] = int(cols[0])
        r_data[i] = int(cols[1])

    var freq = SIMD[dtype, 1024]()
    fast_freq_count(l_data, r_data, freq)
    return  int((l_data * freq).reduce_add())
