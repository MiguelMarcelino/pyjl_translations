using ObjectOriented
@oodef mutable struct MandelbrotComplex
    z::Complex

    function new(z::Complex = 0 + 0im)
        @mk begin
            z = z
        end
    end


end
function mandelbrot(limit, c)::Int64
    mc = MandelbrotComplex()
    i = 0
    for _i = 0:limit
        i = _i
        if abs(mc.z) > 2
            return i
        end
    end
    mc.z = mc.z * mc.z + c
    return i + 1
end

if abspath(PROGRAM_FILE) == @__FILE__
    mandelbrot(parse(Int, ARGS[1]), 0.2 + 0.3im)
end
