defmodule Noether.Maybe do
  @moduledoc nil

  alias Noether.Either

  @doc """
  Given a value and a function, the function is applied only if the value is different from `nil`. `nil` is returned otherwise.

  ## Examples

      iex> map(nil, &Kernel.abs/1)
      nil

      iex> map(-1, &Kernel.abs/1)
      1
  """
  @spec map(any(), fun()) :: any()
  def map(nil, _), do: nil
  def map(v, f), do: f.(v)

  @doc """
  Given a value and a default, `{:ok, value}` is returned only if the value is different from `nil`. `{:error, default}` is returned otherwise.

  ## Examples

      iex> required(nil, :hello)
      {:error, :hello}

      iex> required(1, :hello)
      {:ok, 1}
  """
  @spec required(any(), any()) :: Either.either()
  def required(nil, default), do: {:error, default}
  def required(v, _), do: {:ok, v}

  @doc """
  Given a list, it returns `{:ok, list}` if every element of the list is different from nil. Otherwise `{:error, :nil_found}` is returned.

  ## Examples

      iex> sequence([1, 2])
      {:ok, [1, 2]}

      iex> sequence([1, nil, 3])
      {:error, :nil_found}
  """
  @spec sequence([any()]) :: Either.either()
  def sequence(list) do
    list
    |> Enum.reduce(
      {:ok, []},
      fn
        _, e = {:error, _} -> e
        nil, _ -> {:error, :nil_found}
        value, {:ok, acc} -> {:ok, [value | acc]}
      end
    )
    |> Either.map(&Enum.reverse/1)
  end

  @doc """
  Given a value, a function, and a default, it applies the function on the value if the latter is different from `nil`. It returns the default otherwise.

  ## Examples

      iex> maybe(-1, &Kernel.abs/1, :hello)
      1

      iex> maybe(nil, &Kernel.abs/1, :hello)
      :hello
  """
  @spec maybe(any(), fun(), any()) :: any()
  def maybe(nil, _, default), do: default
  def maybe(value, f, _), do: f.(value)

  @doc """
  Given a list of values, the function is mapped only on the elements different from `nil`. `nil` values will be discarded. A list of the results is returned.

  ## Examples
      iex> cat_maybe([1], &(&1 + 1))
      [2]

      iex> cat_maybe([1, nil, 3], &(&1 + 1))
      [2, 4]
  """
  @spec cat_maybe([any()], fun()) :: [any()]
  def cat_maybe(list, f) do
    list
    |> Enum.reduce([], fn
      nil, acc -> acc
      a, acc -> [f.(a) | acc]
    end)
    |> Enum.reverse()
  end

  @doc """
  Given a value and two functions, it applies the first one and returns the result if it's different from nil. Otherwise the second function is applied.

  ## Examples

      iex> choose(0, fn a -> a + 1 end, fn b -> b + 2 end)
      1

      iex> choose(0, fn _ -> nil end, fn b -> b + 2 end)
      2

      iex> choose(0, fn _ -> nil end, fn _ -> nil end)
      nil
  """
  @spec choose(any(), fun(), fun()) :: any()
  def choose(a, f, g) do
    b = f.(a)

    if is_nil(b) do
      g.(a)
    else
      b
    end
  end
end
