"""
    load_env_file(file::String)

Load environment variables from a file. The file must contain the required variables from
the `.env.sample` file. If the file does not exist, the function does nothing.
"""
function load_env_file(file::String)
    if isfile(file)
        for line in eachline(file)
            if !startswith(line, "#") && !isempty(line)
                key, value = split(line, "=", limit=2)
                ENV[key] = value
            end
        end
    end
end
