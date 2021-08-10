defmodule BintreeUtilsTest do
  use ExUnit.Case

  test "delete duplicated branches" do
    tree =
      Bintree.new(1, &(&1 + 1), &(&1 - 1), 4)
      |> Bintree.Utils.remove_duplicates()

    assert tree ==
             Bintree.new(
               1,
               Bintree.new(2, Bintree.new(3, 4)),
               Bintree.new(0, nil, Bintree.new(-1, nil, -2))
             )
  end
end
