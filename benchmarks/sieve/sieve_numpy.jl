function sieve(n)
    primes = trues(n)
    (primes[1], primes[2]) = (false, false)
    for i = 2:Int(floor(sqrt(n) + 1))-1
        if primes[i+1]
            primes[i*i+1:i:end] .= false
        end
    end
    return [i-1 for (i,p) in enumerate(primes) if p != 0]
end

if abspath(PROGRAM_FILE) == @__FILE__
    sieve(parse(Int, append!([PROGRAM_FILE], ARGS)[2]))
end