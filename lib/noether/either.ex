defmodule Noether.Either do
  @moduledoc """
  This module hosts several utility functions to work with `{:ok, _} | {:error, _}` values.
  These type of values will be then called `Either`.
  """

  @type either :: {:ok, any()} | {:error, any()}

  @doc """
  Given an `{:ok, value}` and a function, it applies the function on the `value` returning `{:ok, f.(value)}`.
  If an `{:error, _}` is given, it is returned as-is.

  ## EXAMPLES
    iex> map({:ok, -1}, &Kernel.abs/1)
    {:ok, 1}

    iex> map({:error, "Value not found"}, &Kernel.abs/1)
    {:error, "Value not found"}
  """
  @spec map(either(), fun()) :: either()
  def map({:ok, a}, f), do: {:ok, f.(a)}
  def map(any = {:error, _}, _), do: any

  @doc """
  Given an `{:ok, value}` and a function that returns an Either value, it applies the function on the `value`. It effectively "squashes" an `{:ok, {:ok, v}}` or `{:ok, {:error, _}}` to its most appropriate representation.
  If an `{:error, _}` is given, it is returned as-is.

  ## EXAMPLES
    iex> bind({:ok, 1}, fn a -> {:ok, a + 1} end)
    {:ok, 2}

    iex> bind({:ok, 1}, fn _ -> {:error, 5} end)
    {:error, 5}

    iex> bind({:error, 1}, fn _ -> {:ok, 45} end)
    {:error, 1}
  """
  @spec bind(either(), fun()) :: either()
  def bind({:ok, a}, f), do: f.(a)
  def bind(any = {:error, _}, _), do: any

  @doc """
  Given any value, it makes sure the result is an Either type.

  ## EXAMPLES
    iex> wrap({:ok, 1})
    {:ok, 1}

    iex> wrap({:error, 2})
    {:error, 2}

    iex> wrap(3)
    {:ok, 3}
  """
  @spec wrap(any()) :: either()
  def wrap(k = {:ok, _}), do: k
  def wrap(e = {:error, _}), do: e
  def wrap(any), do: {:ok, any}

  @doc """
  It returns the value of an `{:ok, value}` only if such a tuple is given. If not, `nil` is returned.

  ## EXAMPLES
    iex> unwrap({:ok, 1})
    1

    iex> unwrap(2)
    nil
  """
  @spec unwrap({:ok, any()}) :: any()
  def unwrap({:ok, v}), do: v
  def unwrap(_), do: nil

  @doc """
  It returns `true` only if the value given matches a `{:ok, value}` type.

  ## EXAMPLES
    iex> ok?({:ok, 1})
    true

    iex> ok?({:error, 2})
    false

    iex> ok?(3)
    false
  """
  @spec ok?(any()) :: boolean()
  def ok?(any), do: match?({:ok, _}, any)

  @doc """
  It returns `true` only if the value given matches a `{:error, value}` type.

  ## EXAMPLES
    iex> error?({:ok, 1})
    false

    iex> error?({:error, 2})
    true

    iex> error?(3)
    false
  """
  @spec error?(any()) :: boolean()
  def error?(any), do: match?({:error, _}, any)

  @doc """
  Given a list of Either, it returns `{:ok, list}` if every element of the list is of type `{:ok, _}`. Otherwise the first `{:error, _}` is returned.

  ## EXAMPLES
    iex> sequence([{:ok, 1}, {:ok, 2}])
    {:ok, [1, 2]}

    iex> sequence([{:ok, 1}, {:error, 2}, {:ok, 3}])
    {:error, 2}

    iex> sequence([{:error, 1}, {:error, 2}])
    {:error, 1}
  """
  @spec sequence([either()]) :: {:ok, [any()]} | {:error, any()}
  def sequence(list) do
    list
    |> Enum.reduce(
      {:ok, []},
      fn
        _, e = {:error, _} -> e
        e = {:error, _}, _ -> e
        {:ok, value}, {:ok, acc} -> {:ok, [value | acc]}
      end
    )
    |> map(&Enum.reverse/1)
  end

  @doc """
  Given an Either and two functions, it applies the first or second one on the second value of the tuple, depending if the value is `{:ok, _}` or `{:error, _` respectively.

  ## EXAMPLES
    iex> either({:ok, 1}, &(&1 + 1), &(&1 + 2))
    {:ok, 2}

    iex> either({:error, 1}, &(&1 + 1), &(&1 + 2))
    {:error, 3}
  """
  @spec either(either(), fun(), fun()) :: either()
  def either(k = {:ok, _}, f, _), do: map(k, f)
  def either({:error, value}, _, g), do: {:error, g.(value)}

  @doc """
  Given a list of Either, the function is mapped only on the elements of type `{:ok, _}`. Other values will be discarded. A list of the results is returned outside of the tuple.

  ## EXAMPLES
    iex> cat_either([{:ok, 1}], &(&1 + 1))
    [2]

    iex> cat_either([{:ok, 1}, {:error, 2}, {:ok, 3}], &(&1 + 1))
    [2, 4]
  """
  @spec cat_either([either()], fun()) :: [any()]
  def cat_either(list, f) do
    list
    |> Enum.reduce(
      [],
      fn
        {:error, _}, acc -> acc
        {:ok, value}, acc -> [f.(value) | acc]
      end
    )
    |> Enum.reverse()
  end
end
