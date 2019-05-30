defmodule Noether.Maybe do
  @moduledoc nil

  alias Noether.Either

  @doc """
  Given a value and a function, the function is applied only if the value is different from `nil`. `nil` is returned otherwise.

  ## EXAMPLES
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

  ## EXAMPLES
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

  ## EXAMPLES
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

  ## EXAMPLES
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

  ## EXAMPLES
    iex> catMaybe([1], &(&1 + 1))
    [2]

    iex> catMaybe([1, nil, 3], &(&1 + 1))
    [2, 4]
  """
  @spec catMaybe([any()], fun()) :: [any()]
  def catMaybe(list, f) do
    list
    |> Enum.reduce([], fn
      nil, acc -> acc
      a, acc -> [f.(a) | acc]
    end)
    |> Enum.reverse()
  end
end
