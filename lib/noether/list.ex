defmodule Noether.List do
  @moduledoc nil

  import Noether
  alias Noether.Either

  @type fun1 :: (any() -> any())
  @type fun2 :: (any(), any() -> any())

  @doc """
  Given two lists and a function of arity 2, the lists are first zipped and then each tuple is applied (curried) to the function.

  ## Examples

      iex> zip_with([1, 2, 3], [4, 5, 6], &Kernel.+/2)
      [5, 7, 9]
  """
  @spec zip_with([any()], [any()], fun2()) :: [any()]
  def zip_with(a, b, f) when is_function(f, 2) do
    a
    |> Enum.zip(b)
    |> Enum.map(&curry(&1, f))
  end

  @doc """
  Given a predicate, a function of arity 1, and a value, the function is applied repeatedly until the predicate applied to the value returns either `nil`, `false`, or `{:error, _}`. The list of results is returned.

  ## Examples

      iex> until(fn a -> a < 10 end, &(&1 + 1), 0)
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  """
  @spec until(fun1(), fun1(), any()) :: [any()]
  def until(p, f, a) when is_function(p, 1) and is_function(f, 1) do
    case p.(a) do
      nil ->
        []

      false ->
        []

      {:error, _} ->
        []

      _ ->
        [a] ++ until(p, f, f.(a))
    end
  end

  @doc """
  Given a list, it returns `{:ok, list}` if every element of the list is different from nil. Otherwise `{:error, :nil_found}` is returned.

  ## Examples

      iex> sequence([1, 2])
      {:ok, [1, 2]}

      iex> sequence([1, nil, 3])
      {:error, :nil_found}

      iex> sequence([{:ok, 1}, {:ok, 2}])
      {:ok, [1, 2]}

      iex> sequence([{:ok, 1}, {:error, 2}, {:ok, 3}])
      {:error, 2}

      iex> sequence([{:error, 1}, {:error, 2}])
      {:error, 1}

  """
  @spec sequence([any()]) :: {:ok, [any()]} | {:error, any()}
  def sequence(a) do
    a
    |> Enum.reduce_while(
      {:ok, []},
      fn
        _, error = {:error, _} -> {:halt, error}
        error = {:error, _}, _ -> {:halt, error}
        nil, _ -> {:halt, {:error, :nil_found}}
        {:ok, b}, {:ok, acc} -> {:cont, {:ok, [b | acc]}}
        b, {:ok, acc} -> {:cont, {:ok, [b | acc]}}
      end
    )
    |> Either.map(&Enum.reverse/1)
  end
end
