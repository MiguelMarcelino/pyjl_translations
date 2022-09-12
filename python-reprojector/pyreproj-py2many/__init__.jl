module pyreproj
using Formatting
using FromFile: @from
using HTTP
using Parameters
using PyCall
pyproj = pyimport("pyproj")
functools = pyimport("functools")
shapely_ops = pyimport("shapely.ops")
shapely_geo_base = pyimport("shapely.geometry.base")





@from "exception/__init__.jl" using exception: InvalidFormatError, InvalidTargetError
abstract type AbstractReprojector end
__version__ = "2.0.0"
@with_kw mutable struct Reprojector <: AbstractReprojector
    #= 
        Creates a new Reprojector instance.

        :param srs_service_url: The url of the service to be used by get_projection_from_service.
            It can contain a parameter "{epsg}"
        :type srs_service_url: :obj:`str`, optional
         =#
    srs_service_url::String
    Reprojector(
        srs_service_url::String = "http://spatialreference.org/ref/epsg/{epsg}/proj4/",
    ) = new(srs_service_url)
end
function get_transformation_function(
    self::AbstractReprojector,
    from_srs = 4326,
    to_srs = 4326,
)
    #= 
            This method creates a transformation function to transform coordinates from one reference system to
            another one. The projections are set using the two parameters which can match one of the following
            types each:

            - **int:** The EPSG code as integer
            - **str:** The proj4 definition string or the EPSG code as string including the "epsg:" prefix.
            - **pyproj.Proj:** An instance of :class:`pyproj.Proj`, for example as returned by
              :func:`~pyreproj.Reprojector.get_projection_from_service`.

            :param from_srs: Spatial reference system to transform from. Defaults to 4326.
            :type from_srs: :obj:`int`, :obj:`str`, :obj:`pyproj.Proj`
            :param to_srs: Spatial reference system to transform to. Defaults to 4326.
            :type to_srs: :obj:`int`, :obj:`str`, :obj:`pyproj.Proj`
            :return: A function accepting two arguments, x and y.
            :rtype: :func:`functools.partial`
             =#
    return functools.partial(
        pyproj.transform,
        _get_proj_from_parameter(self, from_srs),
        _get_proj_from_parameter(self, to_srs),
    )
end

function get_projection_from_service(self::AbstractReprojector, epsg = 4326)
    #= 
            Sends a request to the set service with the given EPSG code and create an instance of
            :class:`pyproj.Proj` from the received definition.

            :param epsg: The EPSG code for the projection.
            :type epsg: :obj:`int`
            :return: The resulting projection for the received definition.
            :rtype: :obj:`pyproj.Proj`
             =#
    url_ = format(replace(self.srs_service_url, "{epsg}" => "{1}"), epsg)
    response = HTTP.get(url_)
    if response.status == 200
        return pyproj.Proj(String(response.body))
    end
    raise_for_status(response)
end

transform(; self::AbstractReprojector, target, from_srs = 4326, to_srs = 4326) =
    transform(self, target, from_srs, to_srs)
transform(self::AbstractReprojector; target, from_srs = 4326, to_srs = 4326) =
    transform(self, target, from_srs, to_srs)
transform(self::AbstractReprojector, target; from_srs = 4326, to_srs = 4326) =
    transform(self, target, from_srs, to_srs)
function transform(self::AbstractReprojector, target, from_srs = 4326, to_srs = 4326)
    from_proj = _get_proj_from_parameter(self, from_srs)
    to_proj = _get_proj_from_parameter(self, to_srs)
    if isa(target, Vector) && length(target) > 1
        return _transform_list(self, target, from_proj, to_proj)
    elseif isa(target, Tuple)
        return _transform_tuple(self, target, from_proj, to_proj)
    elseif pybuiltin(:isinstance)(target, shapely_geo_base.BaseGeometry)
        return _transform_shapely(self, target, from_proj, to_proj)
    else
        msg = "Invalid target to transform. Valid targets are [x, y], (x, y) or a shapely geometry object."
        throw(InvalidTargetError(msg))
    end
end

function _transform_list(self::AbstractReprojector, target, from_proj, to_proj)::Vector
    # Wrapper arround _transform_list to support static methods
    _transform_list(target, from_proj, to_proj)
end

function _transform_list(target, from_proj, to_proj)::Vector
    (x, y) = pyproj.transform(from_proj, to_proj, target[1], target[2])
    return [x, y]
end

function _transform_tuple(self::AbstractReprojector, target, from_proj, to_proj)::Tuple
    # Wrapper arround _transform_tuple to support static methods
    _transform_tuple(target, from_proj, to_proj)
end

function _transform_tuple(target, from_proj, to_proj)::Tuple
    (x, y) = pyproj.transform(from_proj, to_proj, target[1], target[2])
    return (x, y)
end

function _transform_shapely(self::AbstractReprojector, target, from_proj, to_proj)
    project = get_transformation_function(self, from_proj, to_proj)
    return shapely_ops.transform(project, target)
end

function _get_proj_from_parameter(self::AbstractReprojector, param)
    # Wrapper arround _get_proj_from_parameter to support static methods
    _get_proj_from_parameter(param)
end

function _get_proj_from_parameter(param)
    msg = "Invalid projection definition. Valid formats are \"pyproj.Proj object\", EPSG code as integer or string with leading \"epsg:\" or a proj4 definition string"
    if pybuiltin(:isinstance)(param, pyproj.Proj)
        proj = param
    elseif isa(param, String) && startswith(lowercase(param), "epsg:")
        proj = pyproj.Proj(projparams = parse(Int, param[6:end]))
    else
        try
            proj = pyproj.Proj(projparams = param)
        catch exn
            if exn isa PyCall.PyError && pybuiltin(:issubclass)(exn.T, py"RuntimeError")
                throw(InvalidFormatError(msg))
            end
        end
    end
    return proj
end

end
