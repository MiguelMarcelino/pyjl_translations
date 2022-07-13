function comb_sort(
    seq::Vector{Int64})::Vector{Int64}
  let seq = OffsetArray(seq, -1)
    gap = length(seq)
    swap = true
    while gap > 1 || swap
      gap = max(1,floor(Int, gap / 1.25))
      swap = false
      for i = 0:length(seq) - gap - 1
        if seq[i] > seq[i + gap]
          seq[i], seq[i + gap] = 
            (seq[i + gap], seq[i])
          swap = true
        end
      end
    end
  end
  return seq
end