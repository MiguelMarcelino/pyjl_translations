using OffsetArrays

function sieve(n::Int64)
    primes = OffsetArray(repeat([true], n), -1)
    primes[0], primes[1] = (false, false)
    for i = 2:Int(floor(sqrt(n) + 1))-1
        if primes[i]
            for j = i*i:i:n-1
                primes[j] = false
            end
        end
    end
    return collect(filter((j) -> primes[j], 2:n-1))
end

if abspath(PROGRAM_FILE) == @__FILE__
    sieve(parse(Int, append!([PROGRAM_FILE], ARGS)[2]))
end
