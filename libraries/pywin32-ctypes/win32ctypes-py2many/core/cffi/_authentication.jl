# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _authentication
using FromFile: @from

@from "../core/compat.jl" using compat: is_text
@from "_util.jl" using _util: ffi, check_zero, dlls
@from "_nl_support.jl" using _nl_support: _GetACP
@from "_common.jl" using _common: _PyBytes_FromStringAndSize
abstract type Abstract_CREDENTIAL end
ffi.cdef(
    "\n\ntypedef struct _FILETIME {\n  DWORD dwLowDateTime;\n  DWORD dwHighDateTime;\n} FILETIME, *PFILETIME;\n\ntypedef struct _CREDENTIAL_ATTRIBUTE {\n  LPWSTR Keyword;\n  DWORD  Flags;\n  DWORD  ValueSize;\n  LPBYTE Value;\n} CREDENTIAL_ATTRIBUTE, *PCREDENTIAL_ATTRIBUTE;\n\ntypedef struct _CREDENTIAL {\n  DWORD                 Flags;\n  DWORD                 Type;\n  LPWSTR                TargetName;\n  LPWSTR                Comment;\n  FILETIME              LastWritten;\n  DWORD                 CredentialBlobSize;\n  LPBYTE                CredentialBlob;\n  DWORD                 Persist;\n  DWORD                 AttributeCount;\n  PCREDENTIAL_ATTRIBUTE Attributes;\n  LPWSTR                TargetAlias;\n  LPWSTR                UserName;\n} CREDENTIAL, *PCREDENTIAL;\n\n\nBOOL WINAPI CredReadW(\n    LPCWSTR TargetName, DWORD Type, DWORD Flags, PCREDENTIAL *Credential);\nBOOL WINAPI CredWriteW(PCREDENTIAL Credential, DWORD);\nVOID WINAPI CredFree(PVOID Buffer);\nBOOL WINAPI CredDeleteW(LPCWSTR TargetName, DWORD Type, DWORD Flags);\n\n",
)
_keep_alive = WeakKeyDictionary()
SUPPORTED_CREDKEYS =
    Set(("Type", "TargetName", "Persist", "UserName", "Comment", "CredentialBlob"))
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

mutable struct _CREDENTIAL <: Abstract_CREDENTIAL

end
function __call__(self::Abstract_CREDENTIAL)
    return ffi.new("PCREDENTIAL")[1]
end

function fromdict(cls, credential, flag = 0)
    unsupported = Set(keys(credential)) - SUPPORTED_CREDKEYS
    if length(unsupported) != 0
        throw(ValueError("Unsupported keys: $(unsupported)"))
    end
    if flag != 0
        throw(ValueError("flag != 0 not yet supported"))
    end
    factory = cls()
    c_creds = factory()
    values_ = []
    for key in SUPPORTED_CREDKEYS
        if key ∈ credential
            if key == "CredentialBlob"
                blob = make_unicode(credential["CredentialBlob"])
                blob_data = ffi.new("wchar_t[]", blob)
                c_creds.CredentialBlobSize = ffi.sizeof(blob_data) - ffi.sizeof("wchar_t")
                c_creds.CredentialBlob = ffi.cast("LPBYTE", blob_data)
                push!(values_, blob_data)
            elseif key ∈ ("Type", "Persist")
                setfield!(c_creds, :key, credential[key+1])
            else
                blob = make_unicode(credential[key+1])
                value = ffi.new("wchar_t[]", blob)
                push!(values_, value)
                setfield!(c_creds, :key, ffi.cast("LPTSTR", value))
            end
        end
    end
    _keep_alive[c_creds+1] = tuple(values_)
    return c_creds
end

CREDENTIAL = _CREDENTIAL()
function PCREDENTIAL(value = nothing)
    return ffi.new("PCREDENTIAL", value === nothing ? (ffi.NULL) : (value))
end

function PPCREDENTIAL(value = nothing)
    return ffi.new("PCREDENTIAL*", value === nothing ? (ffi.NULL) : (value))
end

function credential2dict(pc_creds)::Dict
    credentials = Dict()
    for key in SUPPORTED_CREDKEYS
        if key == "CredentialBlob"
            data = _PyBytes_FromStringAndSize(
                pc_creds.CredentialBlob,
                pc_creds.CredentialBlobSize,
            )
        elseif key ∈ ("Type", "Persist")
            data = convert(Int, getfield(pc_creds, :key))
        else
            string_pointer = getfield(pc_creds, :key)
            if string_pointer == ffi.NULL
                data = ""
            else
                data = ffi.string(string_pointer)
            end
        end
        credentials[key] = data
    end
    return credentials
end

function _CredRead(TargetName, Type, Flags, ppCredential)::ErrorWhen
    target = make_unicode(TargetName)
    value =
        check_zero(CredReadW(dlls.advapi32, target, Type, Flags, ppCredential), "CredRead")
    return value
end

function _CredWrite(Credential, Flags)
    return check_zero(CredWriteW(dlls.advapi32, Credential, Flags), "CredWrite")
end

function _CredDelete(TargetName, Type, Flags)
    return check_zero(
        CredDeleteW(dlls.advapi32, make_unicode(TargetName), Type, Flags),
        "CredDelete",
    )
end

_CredFree = Libdl.dlsym(dlls.advapi32, :CredFree)
end
