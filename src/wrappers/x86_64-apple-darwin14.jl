# Autogenerated wrapper script for lrslib_jll for x86_64-apple-darwin14
export liblrs, lrs

using GMP_jll
## Global variables
PATH = ""
LIBPATH = ""
LIBPATH_env = "DYLD_FALLBACK_LIBRARY_PATH"

# Relative path to `liblrs`
const liblrs_splitpath = ["lib", "liblrs.0.0.0.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
liblrs_path = ""

# liblrs-specific global declaration
# This will be filled out by __init__()
liblrs_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const liblrs = "@rpath/liblrs.0.dylib"


# Relative path to `lrs`
const lrs_splitpath = ["bin", "lrs"]

# This will be filled out by __init__() for all products, as it must be done at runtime
lrs_path = ""

# lrs-specific global declaration
function lrs(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
    global PATH, LIBPATH
    env_mapping = Dict{String,String}()
    if adjust_PATH
        if !isempty(get(ENV, "PATH", ""))
            env_mapping["PATH"] = string(PATH, ':', ENV["PATH"])
        else
            env_mapping["PATH"] = PATH
        end
    end
    if adjust_LIBPATH
        if !isempty(get(ENV, LIBPATH_env, ""))
            env_mapping[LIBPATH_env] = string(LIBPATH, ':', ENV[LIBPATH_env])
        else
            env_mapping[LIBPATH_env] = LIBPATH
        end
    end
    withenv(env_mapping...) do
        f(lrs_path)
    end
end


"""
Open all libraries
"""
function __init__()
    global artifact_dir = abspath(artifact"lrslib")

    # Initialize PATH and LIBPATH environment variable listings
    global PATH_list, LIBPATH_list
    # We first need to add to LIBPATH_list the libraries provided by Julia
    append!(LIBPATH_list, [joinpath(Sys.BINDIR, Base.LIBDIR, "julia"), joinpath(Sys.BINDIR, Base.LIBDIR)])
    # From the list of our dependencies, generate a tuple of all the PATH and LIBPATH lists,
    # then append them to our own.
    foreach(p -> append!(PATH_list, p), (GMP_jll.PATH_list,))
    foreach(p -> append!(LIBPATH_list, p), (GMP_jll.LIBPATH_list,))

    global liblrs_path = normpath(joinpath(artifact_dir, liblrs_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global liblrs_handle = dlopen(liblrs_path)
    push!(LIBPATH_list, dirname(liblrs_path))

    global lrs_path = normpath(joinpath(artifact_dir, lrs_splitpath...))

    push!(PATH_list, dirname(lrs_path))
    # Filter out duplicate and empty entries in our PATH and LIBPATH entries
    filter!(!isempty, unique!(PATH_list))
    filter!(!isempty, unique!(LIBPATH_list))
    global PATH = join(PATH_list, ':')
    global LIBPATH = join(LIBPATH_list, ':')

    # Add each element of LIBPATH to our DL_LOAD_PATH (necessary on platforms
    # that don't honor our "already opened" trick)
    #for lp in LIBPATH_list
    #    push!(DL_LOAD_PATH, lp)
    #end
end  # __init__()

