module test_get_proj_from_service
using FromFile: @from
using HTTP
using ParameterTests
using PyCall
using Test
requests_mock = pyimport("requests_mock")
pyproj = pyimport("pyproj")



@from "../../__init__.jl" using pyreproj: Reprojector, get_projection_from_service

@paramtest "test_get_proj_from_service_" begin
    @given param ∈ [4326, "4326", "invalid_code"]
    let m = requests_mock.mock()
        m.get(
            "http://spatialreference.org/ref/epsg/4326/proj4/",
            text = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ",
        )
        m.get(
            "http://spatialreference.org/ref/epsg/invalid_code/proj4/",
            text = "Not found, /ref/epsg/invalid_code/proj4/. ",
            status_code = 404,
        )
        rp = Reprojector()
        if param == "invalid_code"
            @test_throws HTTP.Exceptions.StatusError begin
                get_projection_from_service(rp, param)
            end
        else
            proj = get_projection_from_service(rp, param)
            @test(pybuiltin(:isinstance)(proj, pyproj.Proj))
        end
    end
end

end
