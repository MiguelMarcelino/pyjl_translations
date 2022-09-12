module test_get_proj_from_parameter
using FromFile: @from
using PyCall
using Test
pyproj = pyimport("pyproj")

@from "../../__init__.jl" using pyreproj: InvalidFormatError
@from "../../__init__.jl" using pyreproj: Reprojector, _get_proj_from_parameter

function test_get_proj_from_parameter_()
    param_args = [
        "epsg:4326",
        "EPSG:4326",
        4326,
        "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
        pyproj.Proj(init = "epsg:4326"),
    ]
    for param in param_args
        rp = Reprojector()
        proj = _get_proj_from_parameter(rp, param)
        @assert(pybuiltin(:isinstance)(proj, pyproj.Proj))
    end
end

function test_get_proj_from_parameter_invalid()
    param_args = [nothing, "invalid_parameter"]
    for param in param_args
        @test_throws InvalidFormatError begin
            rp = Reprojector()
            _get_proj_from_parameter(rp, param)
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    test_get_proj_from_parameter_()
    test_get_proj_from_parameter_invalid()
end
end
