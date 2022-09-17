using Libdl
using StringEncodings

function load_module()
    cmodule = Libdl.dlopen("./levenshtein.so")
    return cmodule
end

if abspath(PROGRAM_FILE) == @__FILE__
    cmodule = load_module()
    res = ccall(
        Libdl.dlsym(cmodule, :levenshtein),
        Cint,
        (Ptr{Cchar}, Ptr{Cchar}, Cint, Cint, Cint),
        encode("levenshtein", "utf-8"),
        encode("levenstein", "utf-8"),
        Int32(1),
        Int32(1),
        Int32(2),
    )
    println("Levenshtein distance between \'levenshtein\' and \'levenstein\': $(res)")
end
