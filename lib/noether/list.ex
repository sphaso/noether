defmodule Noether.List do
  @moduledoc nil

  import Noether

  @doc """
  Given two lists and a function of arity 2, the lists are first zipped and then each tuple is applied (curried) to the function.

  ## EXAMPLES
    iex> zipWith([1, 2, 3], [4, 5, 6], &Kernel.+/2)
    [5, 7, 9]
  """
  @spec zipWith([any()], [any()], fun()) :: [any()]
  def zipWith(a, b, f) do
    a
    |> Enum.zip(b)
    |> Enum.map(&curry(&1, f))
  end

  # NOPE! predicato, funzione, valore: applica fino a che il predicato non torna false
  # @spec until(nil | [any()], fun()) :: [any()]
  # def until(nil, _), do: []
  # def until([], _), do: []
  # def until([a | t], f) do
  #   if f.(a) do
  #     [a] ++ until(t, f)
  #   else
  #     []
  #   end
  # end
end
