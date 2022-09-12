# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module win32api
#=  A module, encapsulating the Windows Win32 API.  =#
using FromFile: @from
@from "../core/__init__.jl" using core: _backend
@from "../core/ctypes/_common.jl" using _common
@from "../core/ctypes/_dll.jl" using _dll
@from "../core/ctypes/_resource.jl" using _resource
@from "../core/ctypes/_system_information.jl" using _system_information
@from "../core/ctypes/_time.jl" using _time
@from "pywintypes.jl" using pywintypes: pywin32error as _pywin32error
LOAD_LIBRARY_AS_DATAFILE = 2
LANG_NEUTRAL = 0
function LoadLibraryEx(fileName, handle, flags)
    #=  Loads the specified DLL, and returns the handle.

        Parameters
        ----------
        fileName : unicode
            The filename of the module to load.

        handle : int
            Reserved, always zero.

        flags : int
            The action to be taken when loading the module.

        Returns
        -------
        handle : hModule
            The handle of the loaded module

         =#
    if !(handle == 0)
        throw(ValueError("handle != 0 not supported"))
    end
    run(_pywin32error()) do
        return _dll._LoadLibraryEx(fileName, 0, flags)
    end
end

function EnumResourceTypes(hModule)::Vector
    #=  Enumerates resource types within a module.

        Parameters
        ----------
        hModule : handle
            The handle to the module.

        Returns
        -------
        resource_types : list
           The list of resource types in the module.

         =#
    resource_types = []
    function callback(hModule, type_, param)::Bool
        push!(resource_types, type_)
        return true
    end

    run(_pywin32error()) do
        _resource._EnumResourceTypes(hModule, _resource.ENUMRESTYPEPROC(callback), 0)
    end
    return resource_types
end

function EnumResourceNames(hModule, resType)::Vector
    #=  Enumerates all the resources of the specified type within a module.

        Parameters
        ----------
        hModule : handle
            The handle to the module.
        resType : str : int
            The type or id of resource to enumerate.

        Returns
        -------
        resource_names : list
           The list of resource names (unicode strings) of the specific
           resource type in the module.

         =#
    resource_names = []
    function callback(hModule, type_, type_name, param)::Bool
        push!(resource_names, type_name)
        return true
    end

    run(_pywin32error()) do
        _resource._EnumResourceNames(
            hModule,
            resType,
            _resource.ENUMRESNAMEPROC(callback),
            0,
        )
    end
    return resource_names
end

function EnumResourceLanguages(hModule, lpType, lpName)::Vector
    #=  List languages of a resource module.

        Parameters
        ----------
        hModule : handle
            Handle to the resource module.

        lpType : str : int
            The type or id of resource to enumerate.

        lpName : str : int
            The type or id of resource to enumerate.

        Returns
        -------
        resource_languages : list
            List of the resource language ids.

         =#
    resource_languages = []
    function callback(hModule, type_name, res_name, language_id, param)::Bool
        push!(resource_languages, language_id)
        return true
    end

    run(_pywin32error()) do
        _resource._EnumResourceLanguages(
            hModule,
            lpType,
            lpName,
            _resource.ENUMRESLANGPROC(callback),
            0,
        )
    end
    return resource_languages
end

function LoadResource(hModule, type_, name, language = LANG_NEUTRAL)
    #=  Find and Load a resource component.

        Parameters
        ----------
        handle : hModule
            The handle of the module containing the resource.
            Use None for current process executable.

        type : str : int
            The type of resource to load.

        name : str : int
            The name or Id of the resource to load.

        language : int
            Language to use, default is LANG_NEUTRAL.

        Returns
        -------
        resource : bytes
            The byte string blob of the resource

         =#
    run(_pywin32error()) do
        hrsrc = _resource._FindResourceEx(hModule, type_, name, language)
        size_ = _resource._SizeofResource(hModule, hrsrc)
        hglob = _resource._LoadResource(hModule, hrsrc)
        if _backend == "ctypes"
            pointer_ = _common.cast(_resource._LockResource(hglob), _common.c_char_p)
        else
            pointer_ = _resource._LockResource(hglob)
        end
        return _common._PyBytes_FromStringAndSize(pointer, size_)
    end
end

function FreeLibrary(hModule)
    #=  Free the loaded dynamic-link library (DLL) module.

        If necessary, decrements its reference count.

        Parameters
        ----------
        handle : hModule
            The handle to the library as returned by the LoadLibrary function.

         =#
    run(_pywin32error()) do
        return _dll._FreeLibrary(hModule)
    end
end

function GetTickCount()
    #=  The number of milliseconds that have elapsed since startup

        Returns
        -------
        counts : int
            The millisecond counts since system startup.
         =#
    return _time._GetTickCount()
end

function BeginUpdateResource(filename, delete)
    #=  Get a handle that can be used by the :func:`UpdateResource`.

        Parameters
        ----------
        fileName : unicode
            The filename of the module to load.
        delete : bool
            When true all existing resources are deleted

        Returns
        -------
        result : hModule
            Handle of the resource.

         =#
    run(_pywin32error()) do
        return _resource._BeginUpdateResource(filename, delete)
    end
end

function EndUpdateResource(handle, discard)
    #=  End the update resource of the handle.

        Parameters
        ----------
        handle : hModule
            The handle of the resource as it is returned
            by :func:`BeginUpdateResource`

        discard : bool
            When True all writes are discarded.

         =#
    run(_pywin32error()) do
        _resource._EndUpdateResource(handle, discard)
    end
end

function UpdateResource(handle, type_, name, data, language = LANG_NEUTRAL)
    #=  Update a resource.

        Parameters
        ----------
        handle : hModule
            The handle of the resource file as returned by
            :func:`BeginUpdateResource`.

        type : str : int
            The type of resource to update.

        name : str : int
            The name or Id of the resource to update.

        data : bytes
            A bytes like object is expected.

            .. note::
              PyWin32 version 219, on Python 2.7, can handle unicode inputs.
              However, the data are stored as bytes and it is not really
              possible to convert the information back into the original
              unicode string. To be consistent with the Python 3 behaviour
              of PyWin32, we raise an error if the input cannot be
              converted to `bytes`.

        language : int
            Language to use, default is LANG_NEUTRAL.

         =#
    run(_pywin32error()) do
        try
            lp_data = bytes(data)
        catch exn
            if exn isa UnicodeEncodeError
                throw(TypeError("a bytes-like object is required, not a \'unicode\'"))
            end
        end
        _resource._UpdateResource(handle, type_, name, language, lp_data, length(lp_data))
    end
end

function GetWindowsDirectory()::String
    #=  Get the ``Windows`` directory.

        Returns
        -------
        result : str
            The path to the ``Windows`` directory.

         =#
    run(_pywin32error()) do
        return string(_system_information._GetWindowsDirectory())
    end
end

function GetSystemDirectory()::String
    #=  Get the ``System`` directory.

        Returns
        -------
        result : str
            The path to the ``System`` directory.

         =#
    run(_pywin32error()) do
        return string(_system_information._GetSystemDirectory())
    end
end

end
