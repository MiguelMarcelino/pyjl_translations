module test_get_transformation_function
using FromFile: @from
using PyCall
functools = pyimport("functools")

@from "../../__init__.jl" using pyreproj: Reprojector, get_transformation_function
function test_get_transformation_function_()
    rp = Reprojector()
    trf = get_transformation_function(rp, from_srs = 4326, to_srs = 3857)
    @assert(pybuiltin(:isinstance)(trf, functools.partial))
    p = trf(45.0, 45.0)
    @assert(isa(p, Tuple))
    @assert(length(p) == 2)
end

if abspath(PROGRAM_FILE) == @__FILE__
    test_get_transformation_function_()
end
end
