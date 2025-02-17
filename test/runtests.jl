using HTTP
using JSON
using Test
using Compat
using SQLite
using Memoize

using TrackingAPI

TrackingAPI.run(; port=19000)

include("utils.jl")

include("repositories/database.jl")

include("routes/health.jl")

TrackingAPI.stop()
