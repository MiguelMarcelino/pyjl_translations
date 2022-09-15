module test_get_proj_from_parameter
using FromFile: @from
using ParameterTests
using PyCall
using Test
pyproj = pyimport("pyproj")

@from "../../__init__.jl" using pyreproj: InvalidFormatError
@from "../../__init__.jl" using pyreproj: Reprojector, _get_proj_from_parameter

@paramtest "test_get_proj_from_parameter_" begin
    @given param ∈ [
        "epsg:4326",
        "EPSG:4326",
        4326,
        "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
        pyproj.Proj(init = "epsg:4326"),
    ]
    rp = Reprojector()
    proj = _get_proj_from_parameter(rp, param)
    @test(pybuiltin(:isinstance)(proj, pyproj.Proj))
end

@paramtest "test_get_proj_from_parameter_invalid" begin
    @given param ∈ [nothing, "invalid_parameter"]
    @test_throws InvalidFormatError begin
        rp = Reprojector()
        _get_proj_from_parameter(rp, param)
    end
end

end
