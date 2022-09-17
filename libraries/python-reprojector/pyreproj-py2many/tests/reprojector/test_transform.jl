module test_transform
using FromFile: @from
using ParameterTests
using PyCall
using Test
shapely_geo = pyimport("shapely.geometry")


@from "../../__init__.jl" using pyreproj: InvalidTargetError
@from "../../__init__.jl" using pyreproj: Reprojector, transform
@paramtest "test_transform_" begin
    @given (type, target, from_srs, to_srs) ∈ [
        ("tuple", (45.0, 45.0), "EPSG:4326", "EPSG:3857"),
        ("list", [45.0, 45.0], "EPSG:4326", "EPSG:3857"),
        ("shapely", shapely_geo.Point(45.0, 45.0), "EPSG:4326", "EPSG:3857"),
        ("invalid", "not a valid target", "EPSG:4326", "EPSG:3857"),
    ]
    rp = Reprojector()
    if type == "invalid"
        try
            transform(rp, target, from_srs = from_srs, to_srs = to_srs)
        catch exn
            let e = exn
                if e isa InvalidTargetError
                    @test(
                        e.message ==
                        "Invalid target to transform. Valid targets are [x, y], (x, y) or a shapely geometry object."
                    )
                end
            end
        end
    else
        trf = transform(rp, target, from_srs = from_srs, to_srs = to_srs)
        if type == "tuple"
            @test(isa(trf, Tuple))
            @test(length(trf) == 2)
        elseif type == "list"
            @test(isa(trf, Vector))
            @test(length(trf) == 2)
        elseif type == "shapely"
            @test(pybuiltin(:isinstance)(trf, shapely_geo.Point))
        end
    end
end

function test_transform_epsg_2056()
    rp = Reprojector()
    from_srs = 4326
    to_srs = 2056
    xy = (47.48911, 7.72866)
    expected = (2621858.036, 1259856.747)
    trf = transform(rp, xy, from_srs = from_srs, to_srs = to_srs)
    @assert(round(trf[1], digits = 3) == expected[1])
    @assert(round(trf[2], digits = 3) == expected[2])
end

if abspath(PROGRAM_FILE) == @__FILE__
    test_transform_epsg_2056()
end
end
