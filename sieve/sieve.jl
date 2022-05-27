function sieve(n::Int64)
    primes = repeat([true], n)
    primes[1], primes[2] = (false, false)
    for i = 2:Int(sqrt(n) + 1)-1
        if primes[i+1]
            for j = i*i:i:n-1
                primes[j+1] = false
            end
        end
    end
    return [i for i in 0:length(primes)-1 if primes[i+1]]
end

if abspath(PROGRAM_FILE) == @__FILE__
    sieve(parse(Int, sys.argv[2]))
end
