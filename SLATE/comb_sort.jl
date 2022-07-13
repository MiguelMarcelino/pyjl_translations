function comb_sort(seq::Vector{Int})::Vector{Int}
    gap = length(seq)
    swap = true
    while gap > 1 || swap
        gap = max(1, floor(Int, gap / 1.25))
        swap = false
        for i = 0:length(seq)-gap-1
            if seq[i+1] > seq[i+gap+1]
                seq[i+1], seq[i+gap+1] = (seq[i+gap+1], seq[i+1])
                swap = true
            end
        end
    end
    return seq
end
