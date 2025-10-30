"""
    get_parameter_by_id(id::Integer)::Optional{Parameter}

Get a [`Parameter`](@ref) by id.

# Arguments
- `id::Integer`: The id of the parameter to query.

# Returns
A [`Parameter`](@ref) object. If the record does not exist, return `nothing`.
"""
get_parameter_by_id(id::Integer)::Optional{Parameter} = fetch(Parameter, id)

"""
    get_parameters(iteration_id::Integer)::Array{Parameter, 1}

Get all [`Parameter`](@ref) for a given iteration.

# Arguments
- `iteration_id::Integer`: The id of the iteration to query.

# Returns
An array of [`Parameter`](@ref) objects.
"""
function get_parameters(iteration_id::Integer)::Array{Parameter,1}
    return fetch_all(Parameter, iteration_id)
end

"""
    create_parameter(iteration_id::Integer, parameter_payload::ParameterCreatePayload)::Tuple{Optional{<:Int64},UpsertResult}

# Arguments
- `iteration_id::Integer`: The id of the iteration to create the parameter for.
- `parameter_payload::ParameterCreatePayload`: The payload for creating a parameter.

# Returns
An [`UpsertResult`](@ref). [`Created`](@ref) if the record was successfully created, [`Duplicate`](@ref) if the record already exists, [`Unprocessable`](@ref) if the record violates a constraint, and [`Error`](@ref) if an error occurred while creating the record.
"""
function create_parameter(
    iteration_id::Integer, parameter_payload::ParameterCreatePayload
)::Tuple{Optional{<:Int64},UpsertResult}
    iteration = iteration_id |> get_iteration_by_id
    if iteration |> isnothing
        return nothing, Unprocessable()
    end

    parameter_id, parameter_upsert_result = insert(
        Parameter,
        iteration_id,
        parameter_payload.key,
        parameter_payload.value,
    )
    if !(parameter_upsert_result isa Created)
        return nothing, parameter_upsert_result
    end
    return parameter_id, parameter_upsert_result
end

"""
    update_parameter(id::Integer, parameter_payload::ParameterUpdatePayload)::UpsertResult

Update a [`Parameter`](@ref) record.

# Arguments
- `id::Integer`: The id of the parameter to update.
- `parameter_payload::ParameterUpdatePayload`: The payload for updating the parameter.

# Returns
An [`UpsertResult`](@ref). [`Updated`](@ref) if the record was successfully updated (or no changes were made), [`Duplicate`](@ref) if the record already exists, [`Unprocessable`](@ref) if the record violates a constraint, and [`Error`](@ref) if an error occurred while creating the record.
"""
function update_parameter(
    id::Integer, parameter_payload::ParameterUpdatePayload
)::UpsertResult
    parameter = id |> get_parameter_by_id
    if parameter |> isnothing
        return Unprocessable()
    end

    should_be_updated = compare_object_fields(
        parameter;
        key=parameter_payload.key,
        value=parameter_payload.value,
    )
    if !should_be_updated
        return Updated()
    end

    return update(
        Parameter, id;
        key=parameter_payload.key,
        value=parameter_payload.value,
    )
end

"""
    delete_parameter(id::Integer)::Bool

Delete a [`Parameter`](@ref) record.

# Arguments
- `id::Integer`: The id of the parameter to delete.

# Returns
`true` if the record was successfully deleted, `false` otherwise.
"""
delete_parameter(id::Integer)::Bool = delete(Parameter, id)

"""
    delete_parameters(iteration::Iteration)::Bool

Delete all [`Parameter`](@ref) records associated with a given [`Iteration`](@ref).

# Arguments
- `iteration::Iteration`: The iteration whose parameters are to be deleted.

# Returns
`true` if the records were successfully deleted, `false` otherwise.
"""
delete_parameters(iteration::Iteration)::Bool = delete(Parameter, iteration)
