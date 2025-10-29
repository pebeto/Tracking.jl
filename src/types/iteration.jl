"""
    Iteration

A struct representing an iteration within an experiment.

Fields
- `id`: The unique identifier of the iteration.
- `experiment_id`: The identifier of the experiment to which the iteration belongs.
- `notes`: Notes associated with the iteration.
- `created_date`: The date and time when the iteration was created.
- `end_date`: The date and time when the iteration ended, or `nothing` if it is still ongoing.
"""
struct Iteration <: ResultType
    id::Integer
    experiment_id::Integer
    notes::String
    created_date::DateTime
    end_date::Optional{DateTime}
end

"""
    IterationUpdatePayload

A struct representing the payload for updating an existing iteration.

Fields
- `notes`: Notes associated with the iteration.
- `end_date`: The date and time when the iteration ended, or `nothing` if it is still ongoing.
"""
struct IterationUpdatePayload <: UpsertType
    notes::Optional{String}
    end_date::Optional{DateTime}
end
