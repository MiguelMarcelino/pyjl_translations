function comb_sort(seq::Vector{Int})::Vector{Int}
    gap = length(seq)
    swap = true
    while gap > 1 || swap
        gap = max(1, floor(Int, gap / 1.25))
        swap = false
        for i = 1:length(seq)-gap
            if seq[i] > seq[i+gap]
                seq[i], seq[i+gap] = (seq[i+gap], seq[i])
                swap = true
            end
        end
    end
    return seq
end
