defmodule Noether.Maybe do
  @moduledoc nil

  alias Noether.Either
  @type fun1 :: (any() -> any())

  @doc """
  Given a value and a function, the function is applied only if the value is different from `nil`. `nil` is returned otherwise.

  ## Examples

      iex> map(nil, &Kernel.abs/1)
      nil

      iex> map(-1, &Kernel.abs/1)
      1
  """
  @spec map(any(), fun1()) :: any()
  def map(nil, _), do: nil
  def map(a, f) when is_function(f, 1), do: f.(a)

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
  def required(a, _), do: {:ok, a}

  @doc """
  Given a value, a function, and a default, it applies the function on the value if the latter is different from `nil`. It returns the default otherwise.

  ## Examples

      iex> maybe(-1, &Kernel.abs/1, :hello)
      1

      iex> maybe(nil, &Kernel.abs/1, :hello)
      :hello
  """
  @spec maybe(any(), fun1(), any()) :: any()
  def maybe(nil, _, default), do: default
  def maybe(a, f, _) when is_function(f, 1), do: f.(a)

  @doc """
  Given a list of values, the function is mapped only on the elements different from `nil`. `nil` values will be discarded. A list of the results is returned.

  ## Examples
      iex> cat_maybe([1], &(&1 + 1))
      [2]

      iex> cat_maybe([1, nil, 3], &(&1 + 1))
      [2, 4]
  """
  @spec cat_maybe([any()], fun1()) :: [any()]
  def cat_maybe(a, f) when is_function(f, 1) do
    a
    |> Enum.reduce([], fn
      nil, acc -> acc
      b, acc -> [f.(b) | acc]
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
  @spec choose(any(), fun1(), fun1()) :: any()
  def choose(a, f, g) when is_function(f, 1) and is_function(g, 1) do
    b = f.(a)

    if is_nil(b) do
      g.(a)
    else
      b
    end
  end
end
