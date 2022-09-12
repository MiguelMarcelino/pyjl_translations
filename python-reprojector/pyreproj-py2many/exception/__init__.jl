module exception
mutable struct Error <: Exception
    #= Base class for custom exceptions. =#
    message::Any
end
function Base.show(self::Error)
    return repr(self.message)
end
mutable struct InvalidFormatError <: Exception
    #= 
        This exception is thrown if a required parameter doesn't match the expected format or one of the expected
        formats.

        :param msg: Error message for this exception.
        :type msg: :obj:`str`
         =#
    message::Any
end
function Base.show(self::InvalidFormatError)
    return repr(self.message)
end
mutable struct InvalidTargetError <: Exception
    #= 
        This exception is thrown if no valid target is given for a transformation, e.g. with
        :func:`~pyreproj.Reprojector.transform`.

        :param msg: Error message for this exception.
        :type msg: :obj:`str`
         =#
    message::Any
end
function Base.show(self::InvalidTargetError)
    return repr(self.message)
end
end
