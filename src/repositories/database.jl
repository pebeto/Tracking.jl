"""
    get_database()::SQLite.DB

Returns a SQLite database connection. The database file is specified by the
`TRACKINGAPI_DB_FILE` environment variable. If the variable is not set, the
default value is `trackingapi.db` in the current directory.

# Returns
A [`SQLite.DB`](@ref) object.

!!! note
The function is memoized, so the database connection will be reused across calls.
"""
@memoize get_database()::SQLite.DB = SQLite.DB(
    haskey(ENV, "TRACKINGAPI_DB_FILE") ? ENV["TRACKINGAPI_DB_FILE"] : "trackingapi.db"
)

function initialize_database(; database::SQLite.DB=get_database())

end
