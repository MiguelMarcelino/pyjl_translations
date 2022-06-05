using BisectPy
using ResumableFunctions

alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"
iub = collect(
    zip(
        ["a", "c", "g", "t", "B", "D", "H", "K", "M", "N", "R", "S", "V", "W", "Y"],
        append!([0.27, 0.12, 0.12, 0.27], repeat([0.02], 11)),
    ),
)
homosapiens = [
    ("a", 0.302954942668),
    ("c", 0.1979883004921),
    ("g", 0.1975473066391),
    ("t", 0.3015094502008),
]

const SEED = Ref(42 % UInt32)
function genRandom(ia::Int64 = 3877, ic::Int64 = 29573, im::Int64 = 139968)
    SEED[] = ((SEED[] * ia) + ic) % im
    return SEED[] / float(im)
end

function makeCumulative(
    table::Vector{Tuple{String, Float64}},
)::Tuple{Vector{Float64}, Vector{String}}
    P::Vector{Float64} = []
    C::Vector{String} = []
    prob = 0.0
    for (char, p) in table
        prob += p
        P = append!(P, [prob])
        C = append!(C, [char])
    end
    return (P, C)
end

function repeatFasta(src::String, n::Int64)
    width = 60
    r = length(src)
    s = src * src * src[begin:n%r]
    for j in (0:n÷width-1)
        i = j * width % r
        write(stdout, s[(i+1):i+width])
        write(stdout, "\n")
    end
    if (n % width) != 0
        write(stdout, s[(length(s)-n%width+1):end])
        write(stdout, "\n")
    end
end

function randomFasta(table, n::Int64)
    width = 60
    r = (0:width-1)
    gR = genRandom
    bb = bisect_right
    jn = x -> join(x, "")
    probs, chars = makeCumulative(table)
    for j in (0:n÷width-1)
        x = jn([chars[bb(probs, gR())] for i in r])
        write(stdout, x)
        write(stdout, "\n")
    end
    if (n % width) != 0
        write(stdout, jn([chars[bb(probs, gR())] for i = 0:n%width-1]))
        write(stdout, "\n")
    end
end

function main()
    n = parse(Int, append!([PROGRAM_FILE], ARGS)[2])
    write(stdout, ">ONE Homo sapiens alu\n")
    repeatFasta(alu, n * 2)
    write(stdout, ">TWO IUB ambiguity codes\n")
    randomFasta(iub, n * 3)
    write(stdout, ">THREE Homo sapiens frequency\n")
    randomFasta(homosapiens, n * 5)
end

main()
