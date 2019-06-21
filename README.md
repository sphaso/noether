# Noether

[![Build Status](https://travis-ci.com/sphaso/noether.svg?branch=master)](https://travis-ci.com/sphaso/noether)

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

## Examples

Here is a list of real world scenarios where you may find that using constructs like `Maybe` and `Either` make your code less verbose, more straightforward, and easier to read.

Suppose you have a function that returns a list of items, and you want to take the first element (if the list is not empty), apply a function to it, and wrap it in a nice `{:ok, _}` or `{:error, _}` tuple.

Without Noether, you would write something like that:

```elixir
function_that_returns_list_of_items()
|> List.first()
|> update_item(& &1)
|> case do
  nil ->
    {:error, :not_found}

  item ->
    {:ok, item}
end

defp update_item(nil), do: nil
defp update_item(item, f), do: f.(item)
```

It's kind of verbose, especially since you are always typing again the functions that pattern match on `nil` and those that wraps a result in a tuple. And what if `function_that_returns_list_of_items` does not return just a list, but it may return an error as well? That's another `case do`.

Let's see how we could accomplish the same with Noether:

```elixir
alias Noether.Maybe

function_that_returns_list_of_items()
|> List.first()
|> Maybe.map(& &1)
|> Maybe.required(:not_found)
```

`Maybe` operates on nullable values, while `Either` operates on `{:ok, _}` or `{:error, _}` tuples. Let's see how we can reduce the verbosity of elixir `with` operator using `Either.bind/2`.

Suppose you have N calls to different functions, where each one may return a tuple, and finally you want to return the "unwrapped" result to the caller. Normally, you would accomplish it this way:

```elixir
with {:ok, res1} <- f1(),
  {:ok, res2} <- f2(),
  {:ok, res3} <- f3(),
  {:ok, res3} <- f4() do
  res3
end
```

It can easily get frustrating and error-prone to write everytime the same `{:ok, _}` matches. Let's see how we can do this using Noether:

```elixir
alias Noether.Either

f1()
|> Either.bind(&f2/0)
|> Either.bind(&f3/0)
|> Either.bind(&f4/0)
|> Either.unwrap()
```

Easier to read, less verbose, and it encapsulates the handling of `{:ok, _}` tuples. You can focus on writing actual logic instead of repeating the same pattern matches every time.

## Contributing

Feel free to propose any function you deem useful and even vaguely related to the ones currently present.    

`mix test` runs the tests.    
`mix format.all` formats all the files under `lib/`.    
`mix check` checks if the files are formatted; it then runs a linter (`credo`) and a type checker ('dyalixir').    
