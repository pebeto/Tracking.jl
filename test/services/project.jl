@with_trackingapi_test_db begin
    @testset verbose = true "project service" begin
        @testset verbose = true "create project" begin
            @testset verbose = true "with user_id as argument" begin
                user_id, _ = TrackingAPI.create_user("Missy", "Gala", "missy", "gala")
                TrackingAPI.update_user(user_id, nothing, nothing, nothing, true)
                project_id, project_upsert_result = TrackingAPI.create_project(
                    user_id,
                    "Test Project",
                )

                @test project_upsert_result isa TrackingAPI.Created
                @test project_id isa Integer
            end

            @testset verbose = true "with no user_id as argument" begin
                project_id, project_upsert_result = TrackingAPI.create_project(
                    "Test Project",
                )

                @test project_upsert_result isa TrackingAPI.Created
                @test project_id isa Integer

                default_user = TrackingAPI.get_user("default")

                userpermission = TrackingAPI.get_userpermission(
                    default_user.id,
                    project_id,
                )
                @test !(userpermission |> isnothing)
            end
        end

        @testset verbose = true "get project by id" begin
            @testset verbose = true "get project by existing id" begin
                project = TrackingAPI.get_project(1)
                @test project isa TrackingAPI.Project
                @test project.id == 1
                @test project.name == "Test Project"
            end

            @testset verbose = true "get project by non-existing id" begin
                project = TrackingAPI.get_project(9999)
                @test project |> isnothing
            end
        end

        @testset verbose = true "get projects" begin
            projects = TrackingAPI.get_projects()

            @test projects isa Array{TrackingAPI.Project,1}
            @test (projects |> length) == 2
            @test projects[1].id == 1
            @test projects[1].name == "Test Project"
        end

        @testset verbose = true "update project" begin
            @test TrackingAPI.update_project(
                1,
                "Updated Test Project",
                "Updated Description"
            ) isa TrackingAPI.Updated

            project = TrackingAPI.get_project(1)

            @test project.name == "Updated Test Project"
            @test project.description == "Updated Description"
        end

        @testset verbose = true "delete project" begin
            user = TrackingAPI.get_user("default")
            project_id, _ = TrackingAPI.create_project(user.id, "Project to Delete")

            @test TrackingAPI.delete_project(project_id)
            @test TrackingAPI.get_project(project_id) |> isnothing
        end
    end
end
