defmodule Noether.Try do
  @moduledoc """
  This module hosts several utility functions to work with `{:ok, _} | {:error, _}` values.

  """
  @type either :: {:ok, any()} | {:error, any()}
  @type fun0 :: (-> either())
  @type fun1 :: (any() -> any())
  @type fune :: (any() -> either())

  @doc """
  Given a function, it runs the function returning the result of `f.()`. `f` is expected
  to be a function that returns an `either` value.
  If the function throws an exception `e` then it is wrapped into an `{:error, e}`.

  ## Examples

      iex> run(fn -> {:ok, 42} end)
      {:ok, 42}

      iex> run(fn -> String.to_integer("nan") end)
      {:error, %ArgumentError{message: "errors were found at the given arguments:\\n\\n  * 1st argument: not a textual representation of an integer\\n"}}
  """
  @spec run(fun0()) :: either()
  def run(f) when is_function(f, 0) do
    try do
      f.()
    rescue
      e -> {:error, e}
    end
  end

  @doc """
  Given a `value` and a function, it applies the function on the `value` returning `{:ok, f.(value)}`.
  If the function throws an exception `e` then it applies the error function wrap the exception into an `{:error, e}`.

  ## Examples

      iex> map("42", &String.to_integer/1)
      {:ok, 42}

      iex> map("nan", &String.to_integer/1)
      {:error, %ArgumentError{message: "errors were found at the given arguments:\\n\\n  * 1st argument: not a textual representation of an integer\\n"}}
  """
  @spec map(any(), fun1()) :: either()
  def map(value, f) when is_function(f, 1) do
    try do
      {:ok, f.(value)}
    rescue
      e -> {:error, e}
    end
  end

  @doc """
  Given a `value` and two function, it applies the ok function on the `value` returning `{:ok, f.(value)}` if no exception is thrown.
  If the ok function throws an exception `e` then it applies the error function wrap the exception into an `{:error, e}`.

  ## Examples

      iex> try_or_else("42", &String.to_integer/1, fn e -> {:error, e} end)
      {:ok, 42}

      iex> try_or_else("nan", &String.to_integer/1, fn e -> {:error, e} end)
      {:error, %ArgumentError{message: "errors were found at the given arguments:\\n\\n  * 1st argument: not a textual representation of an integer\\n"}}
  """
  @spec try_or_else(any(), fun1(), fune()) :: either()
  def try_or_else(value, f, g \\ fn e -> {:error, e} end)
      when is_function(f, 1) and is_function(g, 1) do
    try do
      {:ok, f.(value)}
    rescue
      e -> g.(e)
    end
  end

  @doc """
  Applies `f` to the given `value`, returning `{:ok, f.(value)}` when no exceptional control flow happens.
  Differently from `map/2`, this function uses `catch`, so it also intercepts `throw/1` (and other low-level
  exits) and wraps the intercepted term inside `{:error, _}`.

  ## Examples

      iex> recover(5, fn value -> value + 1 end)
      {:ok, 6}

      iex> recover(:boom, fn _ -> throw(:boom) end)
      {:error, :boom}

      iex> recover(:fatal, fn _ -> exit(:fatal) end)
      {:error, :fatal}
  """
  @spec recover(any(), fun1()) :: either()
  def recover(value, f) when is_function(f, 1) do
    try do
      {:ok, f.(value)}
    catch
      :throw, reason -> {:error, reason}
      :exit, reason -> {:error, reason}
      :error, reason -> {:error, reason}
    end
  end
end
