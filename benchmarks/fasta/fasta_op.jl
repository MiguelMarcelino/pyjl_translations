using BisectPy

# Key aspects:
# - write is much faster than print/println
# - Vector{UInt8} saves a lot in allocations
# - makeCumulative vs lookup_table --> lookup table uses 
# probability as key and UInt8 as value. Additionally, 
# it avoids the use of bisect_right, which is used in every
# iteration of the randomFasta function when retrieving the 
# nucleotide

const alu = Vector{UInt8}(
    string(
        "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG",
        "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA",
        "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT",
        "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA",
        "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG",
        "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC",
        "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA",
    ),
)
const iub = collect(
    zip(
        Vector{UInt8}(string("acgtBDHKMNRSVWY")),
        append!([0.27, 0.12, 0.12, 0.27], repeat([0.02], 11)),
    ),
)
const homosapiens = collect(
    zip(
        Vector{UInt8}(string("acgt")),
        [0.302954942668, 0.1979883004921, 0.1975473066391, 0.3015094502008],
    ),
)

const SEED = Ref(42 % UInt32)
function genRandom(ia::Int64 = 3877, ic::Int64 = 29573, im::Int64 = 139968)
    SEED[] = ((SEED[] * ia) + ic) % im
    return SEED[] / float(im)
end

function makeCumulative(
    table::Vector{Tuple{UInt8, Float64}},
)::Tuple{Vector{Float64}, Vector{UInt8}}
    P::Vector{Float64} = []
    C::Vector{UInt8} = []
    prob = 0.0
    for (char, p) in table
        prob += p
        push!(P, prob)
        push!(C, char)
    end
    return (P, C)
end

function repeatFasta(src::Vector{UInt8}, n::Int64)
    width = 60
    r = length(src)
    s = append!(src, src, src[begin:n%r])
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

function randomFasta(table::Vector{Tuple{UInt8, Float64}}, n::Int64)
    width = 60
    r = (0:width-1)
    probs::Vector{Float64}, chars::Vector{UInt8} = makeCumulative(table)
    for j in (0:n÷width-1)
        x = [chars[bisect_right(probs, genRandom())] for i in r]
        write(stdout, x)
        write(stdout, "\n")
    end
    if (n % width) != 0
        write(stdout, [chars[bisect_right(probs, genRandom())] for i in (0:n%width-1)])
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
