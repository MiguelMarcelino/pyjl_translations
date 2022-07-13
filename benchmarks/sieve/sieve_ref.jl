using FastPrimeSieve

function sieve(n)
    FastPrimeSieve.SmallSieve(n)
end

if abspath(PROGRAM_FILE) == @__FILE__
    sieve(parse(Int, append!([PROGRAM_FILE], ARGS)[2]))
end

