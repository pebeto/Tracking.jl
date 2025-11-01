# Tracking.jl
*A lightweight but **powerful** experiment tracking tool for Julia.*

[![CI](https://github.com/pebeto/Tracking.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/pebeto/Tracking.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/github/pebeto/Tracking.jl/graph/badge.svg?token=Z01WPRJDNR)](https://codecov.io/github/pebeto/Tracking.jl)

## Features
- A complete experiment tracking solution for Julia.
- Built-in REST API server for remote logging and querying.
- Portable and easy-to-use SQLite backend.
- **Built in Julia**

Learn to use it with the [Tutorial](https://pebeto.github.io/Tracking.jl/dev/tutorial/).

## Installation
You can install Tracking.jl via the Julia package manager:
```julia
using Pkg
Pkg.add("Tracking")
```

or from the REPL, type `]add Tracking`.

## Motivation
Experiment tracking is a crucial aspect of machine learning and data science projects.
It helps you keep track of your experiments, models, hyperparameters, and results.
However, many existing experiment tracking tools are either too complex or not
well-integrated with Julia. This package aims to fill that gap by providing a simple yet
powerful solution specifically designed for Julia users.

## Contributing
Contributions are welcome! If you find a bug or have a feature request, please open an
issue on the [GitHub repository](https://github.com/pebeto/Tracking.jl). Pull requests
are also encouraged. Please make sure to follow the existing
[code style](https://github.com/JuliaDiff/BlueStyle) and include tests for any new
features.
