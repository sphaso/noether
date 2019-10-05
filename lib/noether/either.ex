defmodule Noether.Either do
  @moduledoc """
  This module hosts several utility functions to work with `{:ok, _} | {:error, _}` values.
  These type of values will be then called `Either`.
  """
  @type either :: {:ok, any()} | {:error, any()}
  @type fun1 :: (any() -> any())

  @doc """
  Given an `{:ok, value}` and a function, it applies the function on the `value` returning `{:ok, f.(value)}`.
  If an `{:error, _}` is given, it is returned as-is.

  ## Examples

      iex> map({:ok, -1}, &Kernel.abs/1)
      {:ok, 1}

      iex> map({:error, "Value not found"}, &Kernel.abs/1)
      {:error, "Value not found"}
  """
  @spec map(either(), fun1()) :: either()
  def map({:ok, a}, f) when is_function(f, 1), do: {:ok, f.(a)}
  def map(a = {:error, _}, _), do: a

  @doc """
  Given an `{:ok, {:ok, value}}` it flattens the ok unwrapping the `value` and returning `{:ok, value}`.
  If an `{:error, _}` is given, it is returned as-is.

  ## Examples

      iex> flat_map({:ok, {:ok, 1}}, &(&1 + 1))
      {:ok, 2}

      iex> flat_map({:ok, {:error, "Value not found"}}, &(&1 + 1))
      {:error, "Value not found"}

      iex> flat_map({:ok, 1}, &(&1 + 1))
      ** (FunctionClauseError) no function clause matching in Noether.Either.flat_map/2

      iex> flat_map({:error, "Value not found"}, &(&1 + 1))
      {:error, "Value not found"}
  """
  @spec flat_map(either(), fun1()) :: either()
  def flat_map({:ok, {:ok, a}}, f) when is_function(f, 1), do: {:ok, f.(a)}
  def flat_map({:ok, {:error, a}}, _), do: {:error, a}
  def flat_map(a = {:error, _}, _), do: a

  @doc """
  Given an `{:ok, {:ok, value}}` it flattens the ok unwrapping the `value` and returning `{:ok, value}`.
  If an `{:error, _}` is given, it is returned as-is.

  ## Examples

      iex> join({:ok, {:ok, 1}})
      {:ok, 1}

      iex> join({:ok, 1})
      ** (FunctionClauseError) no function clause matching in Noether.Either.join/1

      iex> join({:error, "Value not found"})
      {:error, "Value not found"}
  """
  @spec join(either()) :: either()
  def join({:ok, {:ok, a}}), do: {:ok, a}
  def join({:ok, {:error, a}}), do: {:error, a}
  def join(a = {:error, _}), do: a

  @doc """
  Given an `{:ok, value}` and a function that returns an Either value, it applies the function on the `value`. It effectively "squashes" an `{:ok, {:ok, v}}` or `{:ok, {:error, _}}` to its most appropriate representation.
  If an `{:error, _}` is given, it is returned as-is.

  ## Examples

      iex> bind({:ok, 1}, fn a -> {:ok, a + 1} end)
      {:ok, 2}

      iex> bind({:ok, 1}, fn _ -> {:error, 5} end)
      {:error, 5}

      iex> bind({:error, 1}, fn _ -> {:ok, 45} end)
      {:error, 1}
  """
  @spec bind(either(), fun1()) :: either()
  def bind({:ok, a}, f) when is_function(f, 1), do: f.(a)
  def bind(a = {:error, _}, _), do: a

  @doc """
  Given any value, it makes sure the result is an Either type.

  ## Examples

      iex> wrap({:ok, 1})
      {:ok, 1}

      iex> wrap({:error, 2})
      {:error, 2}

      iex> wrap(3)
      {:ok, 3}
  """
  @spec wrap(any()) :: either()
  def wrap(a = {:ok, _}), do: a
  def wrap(a = {:error, _}), do: a
  def wrap(a), do: {:ok, a}

  @doc """
  It returns the value of an `{:ok, value}` only if such a tuple is given. If not, the default value (`nil` if not provided) is returned.

  ## Examples

      iex> unwrap({:ok, 1})
      1

      iex> unwrap(2)
      nil

      iex> unwrap({:ok, 1}, :default_value)
      1

      iex> unwrap(2, :default_value)
      :default_value
  """
  @spec unwrap(any()) :: any()
  def unwrap(a, b \\ nil)
  def unwrap({:ok, a}, _), do: a
  def unwrap(_, default), do: default

  @doc """
  It returns `true` only if the value given matches a `{:ok, value}` type.

  ## Examples

      iex> ok?({:ok, 1})
      true

      iex> ok?({:error, 2})
      false

      iex> ok?(3)
      false
  """
  @spec ok?(any()) :: boolean()
  def ok?(a), do: match?({:ok, _}, a)

  @doc """
  It returns `true` only if the value given matches a `{:error, value}` type.

  ## Examples

      iex> error?({:ok, 1})
      false

      iex> error?({:error, 2})
      true

      iex> error?(3)
      false
  """
  @spec error?(any()) :: boolean()
  def error?(a), do: match?({:error, _}, a)

  @doc """
  Given an Either and one function, it applies the function to the `{:error, _}` tuple.

  ## Examples

      iex> map_error({:ok, 1}, &(&1 + 1))
      {:ok, 1}

      iex> map_error({:error, 1}, &(&1 + 1))
      {:error, 2}
  """
  @spec map_error(either(), fun1()) :: either()
  def map_error(a = {:ok, _}, _), do: a
  def map_error({:error, a}, f) when is_function(f, 1), do: {:error, f.(a)}

  @doc """
  Given an Either and two functions, it applies the first or second one on the second value of the tuple, depending if the value is `{:ok, _}` or `{:error, _}` respectively.

  ## Examples

      iex> either({:ok, 1}, &(&1 + 1), &(&1 + 2))
      {:ok, 2}

      iex> either({:error, 1}, &(&1 + 1), &(&1 + 2))
      {:error, 3}
  """
  @spec either(either(), fun1(), fun1()) :: either()
  def either(a = {:ok, _}, f, _) when is_function(f, 1), do: map(a, f)
  def either({:error, a}, _, g) when is_function(g, 1), do: {:error, g.(a)}

  @doc """
  Given a list of Either, the function is mapped only on the elements of type `{:ok, _}`. Other values will be discarded. A list of the results is returned outside of the tuple.

  ## Examples

      iex> cat_either([{:ok, 1}], &(&1 + 1))
      [2]

      iex> cat_either([{:ok, 1}, {:error, 2}, {:ok, 3}], &(&1 + 1))
      [2, 4]
  """
  @spec cat_either([either()], fun1()) :: [any()]
  def cat_either(a, f) when is_function(f, 1) do
    a
    |> Enum.reduce(
      [],
      fn
        {:error, _}, acc -> acc
        {:ok, b}, acc -> [f.(b) | acc]
      end
    )
    |> Enum.reverse()
  end

  @doc """
  Given a value and two functions that return an Either, it applies the first one and returns the result if it matches `{:ok, _}`. Otherwise the second function is applied.

  ## Examples

      iex> choose(0, fn a -> {:ok, a + 1} end, fn b -> {:ok, b + 2} end)
      {:ok, 1}

      iex> choose(0, fn _ -> {:error, 1} end, fn b -> {:ok, b + 2} end)
      {:ok, 2}

      iex> choose(0, fn _ -> {:error, 1} end, fn _ -> {:error, 2} end)
      {:error, 2}
  """
  @spec choose(either(), fun1(), fun1()) :: either()
  def choose(a, f, g) when is_function(f, 1) and is_function(g, 1) do
    b = f.(a)

    if match?({:ok, _}, b) do
      b
    else
      g.(a)
    end
  end
end
