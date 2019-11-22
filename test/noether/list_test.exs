defmodule Noether.ListTest do
  use ExUnit.Case
  doctest Noether.List, import: true
  use ExUnitProperties

  property "verify all the rules for Noether.List.sequence" do
    check all(list <- list_of(integer())) do
      assert(
        case Noether.List.sequence(list) do
          {:ok, _} ->
            true

          {:error, :nil_found} ->
            true

          {:error, _} ->
            true

          _ ->
            false
        end
      )
    end
  end
end
