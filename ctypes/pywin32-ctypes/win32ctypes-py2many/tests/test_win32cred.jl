# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module test_win32cred
using FromFile: @from
using Test



@from "../win32cred.jl" using win32cred
@from "../core/_winerrors.jl" using _winerrors: ERROR_NOT_FOUND
@from "../pywin32/pywintypes.jl" using pywintypes: error
@from "../pywin32/win32cred.jl" using win32cred:
    CredDelete, CredRead, CredWrite, CRED_PERSIST_ENTERPRISE, CRED_TYPE_GENERIC
abstract type AbstractTestCred end
version_file = joinpath(
    os.path,
    dirname(os.path, dirname(os.path, win32cred.__file__)),
    "pywin32.version.txt",
)
if ispath(os.path)
    open(version_file) do handle
        pywin32_build = strip(read(handle))
    end
else
    pywin32_build = nothing
end
mutable struct TestCred <: AbstractTestCred

end
function test_write_to_pywin32(self::AbstractTestCred)
    username = "john"
    password = "doefsajfsakfj"
    comment = "Created by MiniPyWin32Cred test suite"
    target = "$(username)@$(password)"
    credentials = Dict{String,Any}(
        "Type" => CRED_TYPE_GENERIC,
        "TargetName" => target,
        "UserName" => username,
        "CredentialBlob" => password,
        "Comment" => comment,
        "Persist" => CRED_PERSIST_ENTERPRISE,
    )
    CredWrite(credentials)
    res = win32cred.CredRead(TargetName = target, Type = CRED_TYPE_GENERIC)
    @test (res["Type"] == CRED_TYPE_GENERIC)
    @test (res["UserName"] == username)
    @test (res["TargetName"] == target)
    @test (res["Comment"] == comment)
    @test (decode(res["CredentialBlob"], "utf-16") == password)
end

function test_read_from_pywin32(self::AbstractTestCred)
    username = "john"
    password = "doe"
    comment = "Created by MiniPyWin32Cred test suite"
    target = "$(username)@$(password)"
    r_credentials = Dict{String,Any}(
        "Type" => CRED_TYPE_GENERIC,
        "TargetName" => target,
        "UserName" => username,
        "CredentialBlob" => password,
        "Comment" => comment,
        "Persist" => CRED_PERSIST_ENTERPRISE,
    )
    win32cred.CredWrite(r_credentials)
    credentials = CredRead(target, CRED_TYPE_GENERIC)
    @test (credentials["UserName"] == username)
    @test (credentials["TargetName"] == target)
    @test (credentials["Comment"] == comment)
    @test (decode(credentials["CredentialBlob"], "utf-16") == password)
end

function test_read_write(self::AbstractTestCred)
    username = "john"
    password = "doe"
    comment = "Created by MiniPyWin32Cred test suite"
    target = "$(username)@$(password)"
    r_credentials = Dict{String,Any}(
        "Type" => CRED_TYPE_GENERIC,
        "TargetName" => target,
        "UserName" => username,
        "CredentialBlob" => password,
        "Comment" => comment,
        "Persist" => CRED_PERSIST_ENTERPRISE,
    )
    CredWrite(r_credentials)
    credentials = CredRead(target, CRED_TYPE_GENERIC)
    @test (credentials["UserName"] == username)
    @test (credentials["TargetName"] == target)
    @test (credentials["Comment"] == comment)
    @test (decode(credentials["CredentialBlob"], "utf-16") == password)
end

function test_read_doesnt_exists(self::AbstractTestCred)
    target = "Floupi_dont_exists@MiniPyWin"
    @test_throws error CredRead(target, CRED_TYPE_GENERIC)
    @test ctx.exception.winerror
end

function test_delete_simple(self::AbstractTestCred)
    username = "john"
    password = "doe"
    comment = "Created by MiniPyWin32Cred test suite"
    target = "$(username)@$(password)"
    r_credentials = Dict{String,Any}(
        "Type" => CRED_TYPE_GENERIC,
        "TargetName" => target,
        "UserName" => username,
        "CredentialBlob" => password,
        "Comment" => comment,
        "Persist" => CRED_PERSIST_ENTERPRISE,
    )
    CredWrite(r_credentials, 0)
    credentials = CredRead(target, CRED_TYPE_GENERIC)
    @test credentials !== nothing
    CredDelete(target, CRED_TYPE_GENERIC)
    @test_throws error CredRead(target, CRED_TYPE_GENERIC)
    @test (ctx.exception.winerror == ERROR_NOT_FOUND)
    @test (ctx.exception.funcname == "CredRead")
end

function test_delete_doesnt_exists(self::AbstractTestCred)
    target = "Floupi_doesnt_exists@MiniPyWin32"
    @test_throws error CredDelete(target, CRED_TYPE_GENERIC)
    @test (ctx.exception.winerror == ERROR_NOT_FOUND)
    @test (ctx.exception.funcname == "CredDelete")
end

if abspath(PROGRAM_FILE) == @__FILE__
    test_cred = TestCred()
    test_write_to_pywin32(test_cred)
    test_read_from_pywin32(test_cred)
    test_read_write(test_cred)
    test_read_doesnt_exists(test_cred)
    test_delete_simple(test_cred)
    test_delete_doesnt_exists(test_cred)
end
end
