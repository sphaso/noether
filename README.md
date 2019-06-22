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

Without Noether, you would write something like this:

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

That's kind of verbose, especially since you need to type the functions that pattern match on `nil` and those that wrap a result in a tuple. Moreover, what if `function_that_returns_list_of_items` does not return just a list, but it may return an error as well? That's another `case do`!

Let's see how we could accomplish the same with Noether:

```elixir
alias Noether.Maybe

function_that_returns_list_of_items()
|> List.first()
|> Maybe.required(:not_found)
```

`Maybe` operates on nullable values, while `Either` operates on `{:ok, _}` or `{:error, _}` tuples. Let's see how we can reduce the verbosity of elixir `with` operator using `Either.bind/2`.

Suppose you have N chained calls to different functions, where each one may return a tuple, and finally you want to return the "unwrapped" result to the caller. Normally, you would accomplish it this way:

```elixir
with {:ok, _res1} <- f1(),
  {:ok, _res2} <- f2(),
  {:ok, _res3} <- f3(),
  {:ok, res4} <- f4() do
  res4
end
```

It can easily get frustrating and error-prone to write everytime the same `{:ok, _}` matches. Let's see how we can do this using Noether:

```elixir
alias Noether.Either

[f1(), f2(), f3(), f4()]
|> Either.sequence()
|> Either.unwrap()
```

Easier to read, less verbose, and it encapsulates the handling of `{:ok, _}` tuples. You can focus on writing actual logic instead of repeating the same pattern matches every time.

After looking at `Maybe` and `Either`, let's take a look at `List`. Suppose you have two lists of numbers you want to sum in order, just like this:

```elixir
[1, 2, 3]
|> Enum.zip([4, 5, 6])
|> Enum.map(fn {a, b} -> a + b end)
```

Noether has a built-in `zip_with` function coming to the rescue:

```elixir
alias Noether.List, as: NList

NList.zip_with([1, 2, 3], [4, 5, 6], &(&1 + &2))
```

## Contributing

Feel free to propose any function you deem useful and even vaguely related to the ones currently present.    

`mix test` runs the tests.    
`mix format.all` formats all the files under `lib/`.    
`mix check` checks if the files are formatted; it then runs a linter (`credo`) and a type checker ('dyalixir').    
