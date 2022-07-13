
function sieve(n::Int64)::Vector
    primes = repeat([true], n)
    (primes[1], primes[2]) = (false, false)
    for i = 2:Int(floor(sqrt(n) + 1))-1
        if primes[i+1]
            for j = i*i:i:n-1
                primes[j+1] = false
            end
        end
    end
    return collect(filter((j) -> primes[j+1], 2:n-1))
end

if abspath(PROGRAM_FILE) == @__FILE__
    sieve(parse(Int, append!([PROGRAM_FILE], ARGS)[2]))
end