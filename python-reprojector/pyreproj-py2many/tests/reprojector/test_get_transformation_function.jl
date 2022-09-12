module test_get_transformation_function
using FromFile: @from

@from "../../__init__.jl" using pyreproj: Reprojector, get_transformation_function
function test_get_transformation_function_()
    rp = Reprojector()
    trf = get_transformation_function(rp, from_srs = 4326, to_srs = 3857)
    @assert(isa(trf, partial))
    p = trf(45.0, 45.0)
    @assert(isa(p, Tuple))
    @assert(length(p) == 2)
end

end
