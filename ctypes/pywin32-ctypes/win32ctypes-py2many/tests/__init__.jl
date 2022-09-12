# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module tests
using FromFile: @from

@from "../core/__init__.jl" using core: _backend

if "SHOW_TEST_ENV" ∈ keys(ENV)
    is_64bits = typemax(Int) > (2^32)
    write(sys.stderr, "$(repeat("=",30))")
    write(
        sys.stderr,
        "Running on python: $(sys.version) $(is_64bits ? ("64bit") : ("32bit"))",
    )
    write(
        sys.stderr,
        "The executable is: $(joinpath(Base.Sys.BINDIR,Base.julia_exename()))",
    )
    write(sys.stderr, "Using the $(_backend) backend")
    write(sys.stderr, "$(repeat("=",30))")
    flush(sys.stderr)
end
end
