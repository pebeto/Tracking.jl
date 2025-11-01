@testset verbose = true "database utilities" begin
    @testset verbose = true "get database" begin
        @testset "check memoization" begin
            db1 = Tracking.get_database()
            db2 = Tracking.get_database()

            @test db1 === db2
        end
    end

    @testset "initialize database" begin
        Tracking.initialize_database()

        rows = DBInterface.execute(
            Tracking.get_database(),
            "SELECT name FROM sqlite_schema WHERE type='table' ORDER BY name",
        )

        for row in rows
            @test row isa SQLite.Row
            @test keys(row) == [:name]
            table_names = [
                ["user"],
                ["project"],
                ["user_project"],
                ["tag"],
                ["project_tag"],
                ["user_permission"],
                ["experiment"],
                ["iteration"],
                ["parameter"],
                ["metric"],
                ["resource"],
                ["sqlite_sequence"],
            ]
            @test values(row) in table_names
        end
    end
end
