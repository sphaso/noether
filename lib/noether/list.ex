defmodule Noether.List do
  @moduledoc nil

  import Noether

  @doc """
  Given two lists and a function of arity 2, the lists are first zipped and then each tuple is applied (curried) to the function.

  ## EXAMPLES
    iex> zip_with([1, 2, 3], [4, 5, 6], &Kernel.+/2)
    [5, 7, 9]
  """
  @spec zip_with([any()], [any()], fun()) :: [any()]
  def zip_with(a, b, f) do
    a
    |> Enum.zip(b)
    |> Enum.map(&curry(&1, f))
  end

  @doc """
  Given a predicate, a function of arity 1, and a value, the function is applied repeatedly until the predicate applied to the value returns either `nil`, `false`, or `{:error, _}`. The list of results is returned.

  ## EXAMPLES
    iex> until(fn a -> a < 10 end, &(&1 + 1), 0)
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  """
  @spec until(fun(), fun(), any()) :: [any()]
  def until(p, f, a) do
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
end
