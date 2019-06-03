defmodule Noether do
  @moduledoc """
  Noether aims to ease common data manipulation tasks by introducing simple algebraic functions and other utilities.
  Functions and names are inspired (sometimes taken as-is) from Haskell.

  The `Noether.Maybe` module introduces operations on nullable values.    
  The `Noether.Either` module introduces operations on `{:ok, _} | {:error, _}` values.    
  The `Noether.List` module introduces operations on lists.

  The root module has a few simple functions one might find of use.
  """

  @doc """
  Takes a tuple and a function of arity 2. It applies the two values in the tuple to the function.

  ## Examples

      iex> curry({1, 2}, &Kernel.+/2)
      3
  """
  @spec curry(tuple(), fun()) :: any()
  def curry({a, b}, f), do: f.(a, b)

  @doc """
  Takes two values and applies them to a function or arity 1 in form of a tuple.

  ## Examples

      iex> uncurry(1, 2, &(&1))
      {1, 2}
  """
  @spec uncurry(any(), any(), fun()) :: any()
  def uncurry(a, b, f), do: f.({a, b})

  @doc """
  Takes a function of arity 2 and returns the same function with its arguments in reverse order, i.e., "flipped".
  Please note that if a function of different arity is given, a function of arity 2 is returned where the two arguments will be applied to the given function.

  ## Examples

      iex> flip(&Kernel.-/2).(3, 4)
      1
  """
  @spec flip(fun()) :: fun()
  def flip(f), do: fn a, b -> f.(b, a) end
end
