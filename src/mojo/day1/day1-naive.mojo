from collections import Dict
from benchmark import *

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
    var left: List[String] = List[String]()
    var right: List[String] = List[String]()
    
    for i in range(len(lines)):
        try:
            var cols = lines[i].split("  ")
            left.append(cols[0])
            right.append(cols[1])
        except:
            pass
    sort(left)
    sort(right)

    var acc: Int = 0
    for i in range(len(left)):
        try:
            var dist = int(left[i]) - int(right[i])
            acc += abs(dist)
        except:
            pass

    return acc

fn part2(input: String) raises -> Int:
    var lines = input.splitlines()
    var left: List[Int] = List[Int]()
    var right: List[Int] = List[Int]()
    for i in range(len(lines)):
            var cols = lines[i].split("  ")
            left.append(int(cols[0]))
            right.append(int(cols[1]))

    var m_freq = Dict[Int, Int]() # memoized frequency - prevents recounting

    fn get_count(value: Int) -> Int:
        if (value in m_freq):
            try:
                return m_freq[value]
            except:
                pass
        var sum: Int = 0
        for i in range(len(right)):
            if (right[i] == value):
                sum += 1
        m_freq[value] = sum
        return sum

    var score: Int = 0
    for i in range(len(left)):
        score += left[i] * get_count(left[i])

    return score        



