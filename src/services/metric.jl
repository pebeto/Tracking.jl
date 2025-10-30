"""
    get_metric_by_id(id::Integer)::Optional{Metric}

Get a [`Metric`](@ref) by id.

# Arguments
- `id::Integer`: The id of the metric to query.

# Returns
A [`Metric`](@ref) object. If the record does not exist, return `nothing`.
"""
get_metric_by_id(id::Integer)::Optional{Metric} = fetch(Metric, id)

"""
    get_metrics(iteration_id::Integer)::Array{Metric, 1}

Get all [`Metric`](@ref) for a given iteration.

# Arguments
- `iteration_id::Integer`: The id of the iteration to query.

# Returns
An array of [`Metric`](@ref) objects.
"""
get_metrics(iteration_id::Integer)::Array{Metric,1} = fetch_all(Metric, iteration_id)

"""
    create_metric(iteration_id::Integer, metric_payload::MetricCreatePayload)::Tuple{Optional{<:Int64},UpsertResult}

# Arguments
- `iteration_id::Integer`: The id of the iteration to create the metric for.
- `metric_payload::MetricCreatePayload`: The payload for creating a metric.

# Returns
An [`UpsertResult`](@ref). [`Created`](@ref) if the record was successfully created, [`Duplicate`](@ref) if the record already exists, [`Unprocessable`](@ref) if the record violates a constraint, and [`Error`](@ref) if an error occurred while creating the record.
"""
function create_metric(
    iteration_id::Integer, metric_payload::MetricCreatePayload
)::Tuple{Optional{<:Int64},UpsertResult}
    iteration = iteration_id |> get_iteration_by_id
    if iteration |> isnothing
        return nothing, Unprocessable()
    end

    metric_id, metric_upsert_result = insert(
        Metric,
        iteration_id,
        metric_payload.key,
        metric_payload.value,
    )
    if !(metric_upsert_result isa Created)
        return nothing, metric_upsert_result
    end
    return metric_id, metric_upsert_result
end

"""
    update_metric(id::Integer, metric_payload::MetricUpdatePayload)::UpsertResult

Update a [`Metric`](@ref) record.

# Arguments
- `id::Integer`: The id of the metric to update.
- `metric_payload::MetricUpdatePayload`: The payload for updating the metric.

# Returns
An [`UpsertResult`](@ref). [`Updated`](@ref) if the record was successfully updated (or no changes were made), [`Duplicate`](@ref) if the record already exists, [`Unprocessable`](@ref) if the record violates a constraint, and [`Error`](@ref) if an error occurred while creating the record.
"""
function update_metric(
    id::Integer, metric_payload::MetricUpdatePayload
)::UpsertResult
    metric = id |> get_metric_by_id
    if metric |> isnothing
        return Unprocessable()
    end

    should_be_updated = compare_object_fields(
        metric;
        key=metric_payload.key,
        value=metric_payload.value,
    )
    if !should_be_updated
        return Updated()
    end

    return update(
        Metric, id;
        key=metric_payload.key,
        value=metric_payload.value,
    )
end

"""
    delete_metric(id::Integer)::Bool

Delete a [`Metric`](@ref) record.

# Arguments
- `id::Integer`: The id of the metric to delete.

# Returns
`true` if the record was successfully deleted, `false` otherwise.
"""
delete_metric(id::Integer)::Bool = delete(Metric, id)

"""
    delete_metrics(iteration::Iteration)::Bool

Delete all [`Metric`](@ref) records associated with a given [`Iteration`](@ref).

# Arguments
- `iteration::Iteration`: The iteration whose metrics are to be deleted.

# Returns
`true` if the records were successfully deleted, `false` otherwise.
"""
delete_metrics(iteration::Iteration)::Bool = delete(Metric, iteration)
