# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _authentication
using FromFile: @from
using Libdl
using PyCall
ctypes = pyimport("ctypes")



@from "../compat.jl" using compat: is_text
@from "_common.jl" using _common: LPBYTE, _PyBytes_FromStringAndSize
@from "_util.jl" using _util: check_zero_factory, dlls
@from "_nl_support.jl" using _nl_support: _GetACP
abstract type AbstractCREDENTIAL end
SUPPORTED_CREDKEYS =
    Set(("Type", "TargetName", "Persist", "UserName", "Comment", "CredentialBlob"))
mutable struct CREDENTIAL <: AbstractCREDENTIAL
    _fields_::Vector{Tuple{String}}
    CREDENTIAL(
        _fields_::Vector{Tuple{String}} = [
            ("Flags", Culong),
            ("Type", Culong),
            ("TargetName", Cwstring),
            ("Comment", Cwstring),
            ("LastWritten", FILETIME),
            ("CredentialBlobSize", Culong),
            ("CredentialBlob", LPBYTE),
            ("Persist", Culong),
            ("_DO_NOT_USE_AttributeCount", Culong),
            ("__DO_NOT_USE_Attribute", Ptr{Cvoid}),
            ("TargetAlias", Cwstring),
            ("UserName", Cwstring),
        ],
    ) = begin
        _fields_ = _fields_
        new(_fields_)
    end
end
function fromdict(cls, credential, flags = 0)
    unsupported = Set(keys(credential)) - SUPPORTED_CREDKEYS
    if length(unsupported) != 0
        throw(ValueError("Unsupported keys: $(unsupported)"))
    end
    if flags != 0
        throw(ValueError("flag != 0 not yet supported"))
    end
    c_creds = cls()
    c_pcreds = PCREDENTIAL(c_creds)
    ccall("memset", Ptr{Cvoid}, (Ptr{Cvoid}, Cint, Csize_t), c_pcreds, 0, sizeof(c_creds))
    for key in SUPPORTED_CREDKEYS
        if key ∈ credential
            if key != "CredentialBlob"
                setfield!(c_creds, :key, credential[key+1])
            else
                blob = make_unicode(credential["CredentialBlob"])
                blob_data = ctypes.create_unicode_buffer(blob)
                c_creds.CredentialBlobSize = sizeof(blob_data) - sizeof(Cwchar_t)
                c_creds.CredentialBlob = Base.cconvert(LPBYTE, blob_data)
            end
        end
    end
    return c_creds
end

PCREDENTIAL = pointer_from_objref(CREDENTIAL)
function make_unicode(password)
    #=  Convert the input string to unicode.

         =#
    if is_text(password)
        return password
    else
        code_page = _GetACP()
        return decode(password, encoding = string(code_page), errors = "strict")
    end
end

function credential2dict(creds)::Dict
    credential = Dict()
    for key in SUPPORTED_CREDKEYS
        if key != "CredentialBlob"
            credential[key] = getfield(creds, :key)
        else
            blob = _PyBytes_FromStringAndSize(
                Base.cconvert(Ptr{Cchar}, creds.CredentialBlob),
                creds.CredentialBlobSize,
            )
            credential["CredentialBlob"] = blob
        end
    end
    return credential
end

_CredWrite =
    (a0, a1) -> begin
        res = ccall(
            Libdl.dlsym(dlls.advapi32, :CredWriteW),
            Clong,
            (Ptr{Cvoid}, Culong),
            a0,
            a1,
        )
        CredWriteW() = Libdl.dlsym(dlls.advapi32, :CredWriteW)
        return check_zero_factory("CredWrite")
    end
_CredRead =
    (a0, a1, a2, a3) -> begin
        res = ccall(
            Libdl.dlsym(dlls.advapi32, :CredReadW),
            Clong,
            (Cwstring, Culong, Culong, Ptr{Cvoid}),
            a0,
            a1,
            a2,
            a3,
        )
        CredReadW() = Libdl.dlsym(dlls.advapi32, :CredReadW)
        return check_zero_factory("CredRead")
    end
_CredDelete =
    (a0, a1, a2) -> begin
        res = ccall(
            Libdl.dlsym(dlls.advapi32, :CredDeleteW),
            Clong,
            (Cwstring, Culong, Culong),
            a0,
            a1,
            a2,
        )
        CredDeleteW() = Libdl.dlsym(dlls.advapi32, :CredDeleteW)
        return check_zero_factory("CredDelete")
    end
_CredFree = (a0) -> ccall(Libdl.dlsym(dlls.advapi32, :CredFree), Cvoid, (Ptr{Cvoid},), a0)
end
