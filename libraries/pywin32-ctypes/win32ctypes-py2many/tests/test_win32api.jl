# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module test_win32api
using DataTypesBasic
using FromFile: @from
using PyCall
using Test
tempfile = pyimport("tempfile")






@from "../pywin32/win32api.jl" using win32api
@from "../pywin32/__init__.jl" using pywin32
@from "../pywin32/pywintypes.jl" using pywintypes: error

abstract type AbstractTestWin32API end

skip_on_wine = "SKIP_WINE_KNOWN_FAILURES" ∈ keys(ENV)
mutable struct TestWin32API <: AbstractTestWin32API
    module_::Module
    tempdir_::Any
    TestWin32API(module_::Module = pywin32.win32api, tempdir_ = tempfile.mkdtemp()) = begin
        module_ = module_
        tempdir_ = tempdir_
        new(module_, tempdir_)
    end
end
function setUp(self::AbstractTestWin32API)
    self.tempdir_ = tempfile.mkdtemp()
    Base.Filesystem.cp(
        joinpath(Base.Sys.BINDIR, Base.julia_exename()),
        self.tempdir_,
        force = true,
    )
end

function tearDown(self::AbstractTestWin32API)
    Base.Filesystem.rm(self.tempdir_, recursive = True)
end

load_library(
    self::AbstractTestWin32API,
    module_::Module,
    library = joinpath(Base.Sys.BINDIR, Base.julia_exename()),
    flags = 2,
) = @ContextManager function (cont)
    res = nothing
    handle = module_.LoadLibraryEx(library, 0, flags)
    try
        res = cont(handle)
    finally
        module_.FreeLibrary(handle)
    end
    res
end

resource_update(
    self::AbstractTestWin32API,
    module_::Module,
    library = joinpath(Base.Sys.BINDIR, Base.julia_exename()),
) = @ContextManager function (cont)
    res = nothing
    handle = module_.BeginUpdateResource(library, false)
    try
        res = cont(handle)
    finally
        module_.EndUpdateResource(handle, false)
    end
    res
end

function test_load_library_ex(self::AbstractTestWin32API)
    run(load_library(self, win32api)) do expected
        run(load_library(self, self.module_)) do handle
            @test (handle == expected)
        end
    end
    @test_throws error self.module_.LoadLibraryEx("ttt.dll", 0, 2)
end

function test_free_library(self::AbstractTestWin32API)
    run(load_library(self, win32api)) do handle
        @test win32api.FreeLibrary(handle) == 1
        @test (self.module_.FreeLibrary(handle) != 0)
    end
    @test_throws error self.module_.FreeLibrary(-3)
end

function test_enum_resource_types(self::AbstractTestWin32API)
    expected = nothing
    resource_types = nothing
    run(load_library(self, win32api, "shell32.dll")) do handle
        expected = win32api.EnumResourceTypes(handle)
    end
    run(load_library(self, pywin32.win32api, "shell32.dll")) do handle
        resource_types = self.module_.EnumResourceTypes(handle)
    end
    @test (resource_types == expected)
    @test_throws error self.module_.EnumResourceTypes(-3)
end

function test_enum_resource_names(self::AbstractTestWin32API)
    run(load_library(self, win32api, "shell32.dll")) do handle
        resource_types = win32api.EnumResourceTypes(handle)
        for resource_type in resource_types
            expected = win32api.EnumResourceNames(handle, resource_type)
            resource_names = self.module_.EnumResourceNames(handle, resource_type)
            @test (resource_names == expected)
            resource_names =
                self.module_.EnumResourceNames(handle, _id2str(self, resource_type))
            @test (resource_names == expected)
        end
    end
    @test_throws error self.module_.EnumResourceNames(2, 3)
end

function test_enum_resource_languages(self::AbstractTestWin32API)
    resource_type = nothing
    handle = nothing
    handle = run(load_library(self, win32api, "shell32.dll")) do handle
        resource_types = win32api.EnumResourceTypes(handle)
        for _resource_type in resource_types
            resource_type = _resource_type
            resource_names = win32api.EnumResourceNames(handle, resource_type)
            for resource_name in resource_names
                expected =
                    win32api.EnumResourceLanguages(handle, resource_type, resource_name)
                resource_languages = self.module_.EnumResourceLanguages(
                    handle,
                    resource_type,
                    resource_name,
                )
                @test (resource_languages == expected)
                resource_languages = self.module_.EnumResourceLanguages(
                    handle,
                    _id2str(self, resource_type),
                    _id2str(self, resource_name),
                )
                @test (resource_languages == expected)
            end
        end
        return handle
    end
    @test_throws error self.module_.EnumResourceLanguages(handle, resource_type, 2235)
end

function test_load_resource(self::AbstractTestWin32API)
    resource_name = nothing
    resource_type = nothing
    handle = nothing
    handle = run(load_library(self, win32api, "explorer.exe")) do handle
        resource_types = win32api.EnumResourceTypes(handle)
        for _resource_type in resource_types
            resource_type = _resource_type
            resource_names = win32api.EnumResourceNames(handle, resource_type)
            for _resource_name in resource_names
                resource_name = _resource_name
                resource_languages =
                    win32api.EnumResourceLanguages(handle, resource_type, resource_name)
                for resource_language in resource_languages
                    expected = win32api.LoadResource(
                        handle,
                        resource_type,
                        resource_name,
                        resource_language,
                    )
                    resource = self.module_.LoadResource(
                        handle,
                        resource_type,
                        resource_name,
                        resource_language,
                    )
                    resource = self.module_.LoadResource(
                        handle,
                        _id2str(self, resource_type),
                        _id2str(self, resource_name),
                        resource_language,
                    )
                    @test (resource == expected)
                end
            end
        end
        return handle
    end
    @test_throws error self.module_.LoadResource(
        handle,
        resource_type,
        resource_name,
        12435,
    )
end

function test_get_tick_count(self::AbstractTestWin32API)
    @test self > self.module_.GetTickCount()
end

function test_begin_and_end_update_resource(self::AbstractTestWin32API)
    handle = nothing
    count_ = 0
    handle = nothing
    handle = nothing
    module_ = self.module_
    filename = joinpath(os.path, self.tempdir_, "python.exe")
    handle = run(load_library(self, module_, filename)) do handle
        count_ = length(EnumResourceTypes(module_, handle))
        return handle
    end
    handle = BeginUpdateResource(module_, filename, false)
    EndUpdateResource(module_, handle, false)
    handle = run(load_library(self, module_, filename)) do handle
        @test (length(EnumResourceTypes(module_, handle)) == count)
        return handle
    end
    handle = BeginUpdateResource(module_, filename, true)
    EndUpdateResource(module_, handle, true)
    handle = run(load_library(self, module_, filename)) do handle
        @test (length(EnumResourceTypes(module_, handle)) == count)
        return handle
    end
end

function test_begin_removing_all_resources(self::AbstractTestWin32API)
    handle = nothing
    if skip_on_wine
        skipTest(self, "EnumResourceTypes known failure on wine, see #59")
    end
    module_ = self.module_
    filename = joinpath(os.path, self.tempdir_, "python.exe")
    handle = BeginUpdateResource(module_, filename, true)
    EndUpdateResource(module_, handle, false)
    handle = run(load_library(self, module_, filename)) do handle
        @test (length(EnumResourceTypes(module_, handle)) == 0)
        return handle
    end
end

function test_begin_update_resource_with_invalid(self::AbstractTestWin32API)
    if skip_on_wine
        skipTest(self, "BeginUpdateResource known failure on wine, see #59")
    end
    @test_throws error self.module_.BeginUpdateResource("invalid", false)
    @test (context.exception.winerror != 0)
end

function test_end_update_resource_with_invalid(self::AbstractTestWin32API)
    if skip_on_wine
        skipTest(self, "EndUpdateResource known failure on wine, see #59")
    end
    @test_throws error self.module_.EndUpdateResource(-3, false)
    @test (context.exception.winerror != 0)
end

function test_update_resource(self::AbstractTestWin32API)
    resource_type = nothing
    resource_name = nothing
    resource_language = nothing
    resource = nothing
    updated = nothing
    module_ = self.module_
    filename = joinpath(os.path, self.tempdir_, "python.exe")
    run(load_library(self, self.module_, filename)) do handle
        resource_type = EnumResourceTypes(module_, handle)[end]
        resource_name = EnumResourceNames(module_, handle, resource_type)[end]
        resource_language =
            EnumResourceLanguages(module_, handle, resource_type, resource_name)[end]
        resource =
            LoadResource(module_, handle, resource_type, resource_name, resource_language)
    end
    run(resource_update(self, self.module_, filename)) do handle
        UpdateResource(
            module_,
            handle,
            resource_type,
            resource_name,
            resource[begin:end-2],
            resource_language,
        )
    end
    run(load_library(self, self.module_, filename)) do handle
        updated =
            LoadResource(module_, handle, resource_type, resource_name, resource_language)
    end
    @test (length(updated) == length(resource) - 2)
    @test (updated == resource[begin:end-2])
end

function test_update_resource_with_unicode(self::AbstractTestWin32API)
    resource_type = nothing
    resource_name = nothing
    resource_language = nothing
    module_ = self.module_
    filename = joinpath(os.path, self.tempdir_, "python.exe")
    run(load_library(self, module_, filename)) do handle
        resource_type = EnumResourceTypes(module_, handle)[end]
        resource_name = EnumResourceNames(module_, handle, resource_type)[end]
        resource_language =
            EnumResourceLanguages(module_, handle, resource_type, resource_name)[end]
    end
    resource = "Δ"
    run(resource_update(self, module_, filename)) do handle
        @test_throws TypeError UpdateResource(
            module_,
            handle,
            resource_type,
            resource_name,
            resource,
            resource_language,
        )
    end
end

function test_get_windows_directory(self::AbstractTestWin32API)
    expected = win32api.GetWindowsDirectory()
    result = self.module_.GetWindowsDirectory()
    @test isa(self, result)
    @test (lower(result) == "c:\\windows")
    @test (result == expected)
end

function test_get_system_directory(self::AbstractTestWin32API)
    expected = win32api.GetSystemDirectory()
    result = self.module_.GetSystemDirectory()
    @test isa(self, result)
    @test (lower(result) == "c:\\windows\\system32")
    @test (result == expected)
end

function _id2str(self::AbstractTestWin32API, type_id)::String
    if isa(type_id, String) && hasmethod(Base.findfirst, (String, String))
        return type_id
    else
        return "#$(type_id)"
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    test_win32_a_p_i = TestWin32API()
    setUp(test_win32_a_p_i)
    test_load_library_ex(test_win32_a_p_i)
    test_free_library(test_win32_a_p_i)
    test_enum_resource_types(test_win32_a_p_i)
    test_enum_resource_names(test_win32_a_p_i)
    test_enum_resource_languages(test_win32_a_p_i)
    test_load_resource(test_win32_a_p_i)
    test_get_tick_count(test_win32_a_p_i)
    test_begin_and_end_update_resource(test_win32_a_p_i)
    test_begin_removing_all_resources(test_win32_a_p_i)
    test_begin_update_resource_with_invalid(test_win32_a_p_i)
    test_end_update_resource_with_invalid(test_win32_a_p_i)
    test_update_resource(test_win32_a_p_i)
    test_update_resource_with_unicode(test_win32_a_p_i)
    test_get_windows_directory(test_win32_a_p_i)
    test_get_system_directory(test_win32_a_p_i)
    tearDown(test_win32_a_p_i)
end
end
