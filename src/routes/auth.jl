"""
    setup_auth_routes()

This function sets up the authentication-related routes for the API.

!!! warning
    This function is intended for internal use. Users should not call this function directly.
"""
function setup_auth_routes()
    root = router("/auth", tags=["auth"])

    @post root("/") function (::HTTP.Request, parameters::Json{UserLoginPayload})
        user = parameters.payload.username |> get_user_by_username

        if user |> isnothing
            return json(("message" => "User not found"); status=HTTP.StatusCodes.NOT_FOUND)
        end

        if !CompareHashAndPassword(user.password, parameters.payload.password)
            return json(
                ("message" => "Invalid credentials");
                status=HTTP.StatusCodes.UNAUTHORIZED,
            )
        end

        claims = Dict(
            "sub" => user.username,
            "id" => user.id,
            "exp" => (now() + Hour(1)) |> Dates.value,
        )
        jwt = JWT(; payload=claims)
        key = JWKSymmetric(JWTs.MD_SHA256, api_config.jwt_secret |> Array{UInt8,1})
        sign!(jwt, key)

        return json(jwt |> string; status=HTTP.StatusCodes.OK)
    end
end
