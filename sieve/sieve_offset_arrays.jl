using OffsetArrays


function sieve(n::Int64)
    primes = OffsetArray(repeat([true], n), -1)
    primes[0], primes[1] = (false, false)
    for i = 2:Int(sqrt(n) + 1)-1
        if primes[i]
            for j = i*i:i:n-1
                primes[j] = false
            end
        end
    end
    return [i for i in 0:length(primes)-1 if primes[i]]
end

if abspath(PROGRAM_FILE) == @__FILE__
    sieve(parse(Int, sys.argv[2]))
end
