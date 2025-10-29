"""
    get_experiment_by_id(id::Integer)::Optional{Experiment}

Get a [`Experiment`](@ref) by id.

# Arguments
- `id::Integer`: The id of the experiment to query.

# Returns
A [`Experiment`](@ref) object. If the record does not exist, return `nothing`.
"""
get_experiment_by_id(id::Integer)::Optional{Experiment} = fetch(Experiment, id)

"""
    get_experiments(project_id::Integer)::Array{Experiment, 1}

Get all [`Experiment`](@ref) for a given project.

# Arguments
- `project_id::Integer`: The id of the project to query.

# Returns
An array of [`Experiment`](@ref) objects.
"""
function get_experiments(project_id::Integer)::Array{Experiment,1}
    return fetch_all(Experiment, project_id)
end

"""
    create_experiment(project_id::Integer, experiment_payload::ExperimentCreatePayload)::Tuple{Optional{<:Integer},UpsertResult}

Create a [`Experiment`](@ref).

# Arguments
- `project_id::Integer`: The id of the project to create the experiment for.
- `experiment_payload::ExperimentCreatePayload`: The payload for creating an experiment.

# Returns
An [`UpsertResult`](@ref). [`Created`](@ref) if the record was successfully created, [`Duplicate`](@ref) if the record already exists, [`Unprocessable`](@ref) if the record violates a constraint, and [`Error`](@ref) if an error occurred while creating the record.
"""
function create_experiment(
    project_id::Integer, experiment_payload::ExperimentCreatePayload
)::Tuple{Optional{<:Integer},UpsertResult}
    project = project_id |> get_project_by_id
    if project |> isnothing
        return nothing, Unprocessable()
    end

    experiment_id, experiment_upsert_result = insert(
        Experiment,
        project_id,
        experiment_payload.status_id |> Integer,
        experiment_payload.name,
    )
    if !(experiment_upsert_result isa Created)
        return nothing, experiment_upsert_result
    end
    return experiment_id, experiment_upsert_result
end

"""
    update_experiment(id::Integer, experiment_payload::ExperimentUpdatePayload)::UpsertResult

Update a [`Experiment`](@ref) record.

# Arguments
- `id::Integer`: The id of the experiment to update.
- `experiment_payload::ExperimentUpdatePayload`: The payload for updating the experiment.

# Returns
An [`UpsertResult`](@ref). [`Updated`](@ref) if the record was successfully updated (or no changes were made), [`Duplicate`](@ref) if the record already exists, [`Unprocessable`](@ref) if the record violates a constraint, and [`Error`](@ref) if an error occurred while creating the record.
"""
function update_experiment(
    id::Integer, experiment_payload::ExperimentUpdatePayload
)::UpsertResult
    experiment = fetch(Experiment, id)
    if experiment |> isnothing
        return Unprocessable()
    end

    should_be_updated = compare_object_fields(
        experiment;
        status_id=experiment_payload.status_id,
        name=experiment_payload.name,
        description=experiment_payload.description,
        end_date=experiment_payload.end_date,
    )
    if !should_be_updated
        return Updated()
    end

    return update(
        Experiment, id;
        status_id=experiment_payload.status_id |> Integer,
        name=experiment_payload.name,
        description=experiment_payload.description,
        end_date=experiment_payload.end_date,
    )
end

"""
    delete_experiment(id::Int)::Bool

Delete a [`Experiment`](@ref) record. Also deletes all associated [`Iteration`](@ref).

# Arguments
- `id::Int`: The id of the experiment to delete.

# Returns
`true` if the record was successfully deleted, `false` otherwise.
"""
function delete_experiment(id::Int)::Bool
    experiment = fetch(Experiment, id)

    delete_iterations(experiment)
    return delete(Experiment, id)
end

"""
    delete_experiments(project::Project)::Bool

Delete all [`Experiment`](@ref) records associated with a given [`Project`](@ref).

# Arguments
- `project::Project`: The project whose experiments are to be deleted.

# Returns
`true` if the records were successfully deleted, `false` otherwise.
"""
delete_experiments(project::Project)::Bool = delete(Experiment, project)
