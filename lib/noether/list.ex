defmodule Noether.List do
  @moduledoc """
  This module hosts several utility functions to work with lists,
  including sequential validation and recursive list building.
  """

  alias Noether.Either

  @type fun1 :: (any() -> any())

  @doc """
  Given a predicate, a function of arity 1, and a value, the function is applied repeatedly until the predicate applied to the value returns either `nil`, `false`, or `{:error, _}`. The list of results is returned.

  ## Examples

      iex> until(fn a -> a < 10 end, &(&1 + 1), 0)
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  """
  @spec until(fun1(), fun1(), any()) :: [any()]
  def until(p, f, a) when is_function(p, 1) and is_function(f, 1) do
    do_until(p, f, a, [])
  end

  defp do_until(p, f, a, acc) do
    case p.(a) do
      nil -> Enum.reverse(acc)
      false -> Enum.reverse(acc)
      {:error, _} -> Enum.reverse(acc)
      _ -> do_until(p, f, f.(a), [a | acc])
    end
  end

  @doc """
  Given a list, it returns `{:ok, list}` if every element of the list is different from nil or `{:error, _}`. Otherwise `{:error, :nil_found}` is returned.

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
        error = {:error, _}, _ -> {:halt, error}
        nil, _ -> {:halt, {:error, :nil_found}}
        {:ok, b}, {:ok, acc} -> {:cont, {:ok, [b | acc]}}
        b, {:ok, acc} -> {:cont, {:ok, [b | acc]}}
      end
    )
    |> Either.map(&Enum.reverse/1)
  end
end
