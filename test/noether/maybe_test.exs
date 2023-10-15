defmodule Noether.MaybeTest do
  use ExUnit.Case
  doctest Noether.Maybe, import: true
  use ExUnitProperties

  alias Noether.Maybe

  describe "Functor laws" do
    property "Identity" do
      check all(n <- integer()) do
        id = & &1
        assert is_nil(Maybe.map(nil, id))
        assert n == Maybe.map(n, id)
      end
    end

    property "Composition" do
      check all(n <- integer()) do
        assert n |> Maybe.map(&(&1 + 1)) |> Maybe.map(&(&1 * 2)) == Maybe.map(n, &((&1 + 1) * 2))
      end
    end
  end
end
