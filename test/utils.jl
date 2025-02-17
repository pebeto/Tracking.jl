@testset verbose = true "load env file" begin
    @testset "file exists" begin
        file = ".env.trackingapitest"
        open(file, "w") do io
            write(io, "TRACKINGAPI_DB_FILE=trackingapi_test.db")
        end

        TrackingAPI.load_env_file(file)

        @test ENV["TRACKINGAPI_DB_FILE"] == "trackingapi_test.db"

        delete!(ENV, "TRACKINGAPI_DB_FILE")
    end

    @testset "file does not exist" begin
        file = ".env.trackingapitest"
        if isfile(file)
            rm(file)
        end

        TrackingAPI.load_env_file(file)

        @test !haskey(ENV, "TRACKINGAPI_DB_FILE")
    end
end
