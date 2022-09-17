module test_init
using FromFile: @from
@from "../../__init__.jl" using pyreproj: Reprojector
function test_init_()
    rp = Reprojector()
    @assert(isa(rp, Reprojector))
    @assert(hasfield(typeof(rp), :srs_service_url))
    @assert(rp.srs_service_url == "http://spatialreference.org/ref/epsg/{epsg}/proj4/")
end

function test_init_with_srs_service_url()
    rp = Reprojector(srs_service_url = "http://justatest.org/{epsg}")
    @assert(isa(rp, Reprojector))
    @assert(hasfield(typeof(rp), :srs_service_url))
    @assert(rp.srs_service_url == "http://justatest.org/{epsg}")
end

if abspath(PROGRAM_FILE) == @__FILE__
    test_init_()
    test_init_with_srs_service_url()
end
end
