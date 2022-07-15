function newman_conway_sequence(n::Int64)
    f = [0, 1, 1]
    for i = 3:n
        r = f[f[i]+1] + f[i-f[i]+1]
        push!(f, r)
    end
    return r
end