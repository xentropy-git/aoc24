from collections import Dict

fn main() raises:
    print("AOC24 - Day 1")
    part1()
    part2()

fn part1() raises:
    with open("../../input/1.txt", "r") as f:
        var file_text = f.read()

        var lines = file_text.splitlines()
        var left: List[String] = List[String]()
        var right: List[String] = List[String]()
        
        for i in range(len(lines)):
            var cols = lines[i].split("  ")
            left.append(cols[0])
            right.append(cols[1])

        sort(left)
        sort(right)

        var acc: Int = 0
        for i in range(len(left)):
            var dist = int(left[i]) - int(right[i])
            acc += abs(dist)

        print(acc)

fn part2() raises:
    with open("../../input/1.txt", "r") as f:
        var file_text = f.read()

        var lines = file_text.splitlines()
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


        print(score)
            



