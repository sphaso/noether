defmodule Noether.EitherTest do
  use ExUnit.Case
  doctest Noether.Either, import: true
  use ExUnitProperties

  alias Noether.Either

  describe "Functor laws" do
    property "Identity" do
      check all(n <- integer()) do
        id = & &1
        el = {:ok, n}
        elx = {:error, n}
        assert el == Either.map(el, id)
        assert elx == Either.map(elx, id)
        assert el == Either.map_error(el, id)
        assert elx == Either.map_error(elx, id)
      end
    end

    property "Composition" do
      check all(n <- integer()) do
        el = {:ok, n}
        elx = {:error, n}

        assert el |> Either.map(&(&1 + 1)) |> Either.map(&(&1 * 2)) ==
                 Either.map(el, &((&1 + 1) * 2))

        assert elx |> Either.map_error(&(&1 + 1)) |> Either.map_error(&(&1 * 2)) ==
                 Either.map_error(elx, &((&1 + 1) * 2))
      end
    end
  end

  describe "Monad laws" do
    property "Left identity" do
      check all(n <- integer()) do
        assert Either.wrap(Either.bind({:ok, n}, &{:ok, &1 + 1})) == {:ok, n + 1}
      end
    end

    property "Right identity" do
      check all(n <- integer()) do
        assert Either.bind({:ok, n}, &Either.wrap/1) == {:ok, n}
      end
    end

    property "Associativity" do
      check all(n <- integer()) do
        assert Either.bind(Either.bind({:ok, n}, &{:ok, &1 + 1}), &{:ok, &1 * 2}) ==
                 Either.bind({:ok, n}, &{:ok, (&1 + 1) * 2})
      end
    end
  end
end
