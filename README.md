# Noether

[![Build Status](https://travis-ci.org/sphaso/noether.svg?branch=master)](https://travis-ci.org/sphaso/noether)

Noether aims to ease common data manipulation tasks by introducing simple algebraic functions and other utilities.
Functions and names are inspired (sometimes taken as-is) from Haskell.

The `Maybe` module introduces operations on nullable values.
The `Either` module introduces operations on `{:ok, _} | {:error, _}` values.
The `List` module introduces operations on lists.

The root module has a few simple functions one might find of use.

## Installation

```elixir
def deps do
  [
    {:noether, "~> 0.1.0"}
  ]
end
```

## Contributing

Feel free to propose any function you deem useful and even vaguely related to the ones currently present.    

`mix test` runs the tests.    
`mix format.all` formats all the files under `lib/`.    
`mix check` checks if the files are formatted; it then runs a linter (`credo`) and a type checker ('dyalixir').    
