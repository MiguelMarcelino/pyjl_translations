# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module win32cred
#=  Interface to credentials management functions.  =#
using FromFile: @from
@from "../core/__init__.jl" using core: _backend
@from "../core/ctypes/_authentication.jl" using _authentication
@from "../core/ctypes/_common.jl" using _common
@from "pywintypes.jl" using pywintypes: pywin32error as _pywin32error
CRED_TYPE_GENERIC = 1
CRED_PERSIST_SESSION = 1
CRED_PERSIST_LOCAL_MACHINE = 2
CRED_PERSIST_ENTERPRISE = 3
CRED_PRESERVE_CREDENTIAL_BLOB = 0
function CredWrite(Credential, Flags = CRED_PRESERVE_CREDENTIAL_BLOB)
    #=  Creates or updates a stored credential.

        Parameters
        ----------
        Credential : dict
            A dictionary corresponding to the PyWin32 ``PyCREDENTIAL``
            structure.
        Flags : int
            Always pass ``CRED_PRESERVE_CREDENTIAL_BLOB`` (i.e. 0).

         =#
    c_creds = fromdict(_authentication.CREDENTIAL, Credential, Flags)
    c_pcreds = _authentication.PCREDENTIAL(c_creds)
    run(_pywin32error()) do
        _authentication._CredWrite(c_pcreds, 0)
    end
end

function CredRead(TargetName, Type, Flags = 0)
    #=  Retrieves a stored credential.

        Parameters
        ----------
        TargetName : unicode
            The target name to fetch from the keyring.
        Type : int
            One of the CRED_TYPE_* constants.
        Flags : int
            Reserved, always use 0.

        Returns
        -------
        credentials : dict
            ``None`` if the target name was not found or A dictionary
            corresponding to the PyWin32 ``PyCREDENTIAL`` structure.

         =#
    if Type != CRED_TYPE_GENERIC
        throw(ValueError("Type != CRED_TYPE_GENERIC not yet supported"))
    end
    flag = 0
    run(_pywin32error()) do
        if _backend == "cffi"
            ppcreds = _authentication.PPCREDENTIAL()
            _authentication._CredRead(TargetName, Type, flag, ppcreds)
            pcreds = _common.dereference(ppcreds)
        else
            pcreds = _authentication.PCREDENTIAL()
            _authentication._CredRead(TargetName, Type, flag, _common.byreference(pcreds))
        end
    end
    try
        return _authentication.credential2dict(_common.dereference(pcreds))
    finally
        _authentication._CredFree(pcreds)
    end
end

function CredDelete(TargetName, Type, Flags = 0)
    #=  Remove the given target name from the stored credentials.

        Parameters
        ----------
        TargetName : unicode
            The target name to fetch from the keyring.
        Type : int
            One of the CRED_TYPE_* constants.
        Flags : int
            Reserved, always use 0.

         =#
    if !(Type == CRED_TYPE_GENERIC)
        throw(ValueError("Type != CRED_TYPE_GENERIC not yet supported."))
    end
    run(_pywin32error()) do
        _authentication._CredDelete(TargetName, Type, 0)
    end
end

end
