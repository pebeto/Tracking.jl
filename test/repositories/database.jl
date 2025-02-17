@testset verbose = true "get database" begin
    @testset "default database file" begin
        db = TrackingAPI.get_database()

        @test db isa SQLite.DB
        @test db.file == "trackingapi.db"

        "trackingapi.db" |> rm
        TrackingAPI.get_database |> memoize_cache |> empty!
    end

    @testset "custom database file" begin
        ENV["TRACKINGAPI_DB_FILE"] = "trackingapi_test.db"

        db = TrackingAPI.get_database()

        @test db isa SQLite.DB
        @test db.file == "trackingapi_test.db"

        "trackingapi_test.db" |> rm

        delete!(ENV, "TRACKINGAPI_DB_FILE")
        TrackingAPI.get_database |> memoize_cache |> empty!
    end

    @testset "check memoization" begin
        db1 = TrackingAPI.get_database()
        db2 = TrackingAPI.get_database()

        @test db1 === db2

        "trackingapi.db" |> rm
    end
end
