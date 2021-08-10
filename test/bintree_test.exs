defmodule BintreeTest do
  use ExUnit.Case
  doctest Bintree

  describe "creating bintree" do
    test "using value" do
      assert Bintree.new(:some_value) == %Bintree{value: :some_value}
    end

    test "using three values" do
      assert Bintree.new(1, 2, 3) == %Bintree{
               value: 1,
               left: %Bintree{value: 2},
               right: %Bintree{value: 3}
             }
    end

    test "using other bintrees" do
      left = Bintree.new(2)
      right = Bintree.new(3)

      assert Bintree.new(1, left, right) == %Bintree{
               value: 1,
               left: %Bintree{value: 2},
               right: %Bintree{value: 3}
             }
    end

    test "using while-generator" do
      two = %Bintree{value: 2}

      assert Bintree.new(1, &(&1 + 1), &(&1 + 1), &(&1 < 3)) == %Bintree{
               value: 1,
               left: two,
               right: two
             }
    end

    test "using depth-generator" do
      two = %Bintree{value: 2, left: nil, right: nil}
      assert Bintree.new(1, &(&1 + 1), &(&1 + 1), 2) == %Bintree{value: 1, left: two, right: two}
    end
  end

  test "insert new value" do
    tree =
      Bintree.new(123)
      |> Bintree.insert([:left], 6)

    assert tree == %Bintree{value: 123, left: Bintree.new(6)}
  end

  test "update value" do
    tree =
      Bintree.new(123)
      |> Bintree.insert([:left], 6)
      |> Bintree.insert([:left], 5)

    assert tree == %Bintree{value: 123, left: Bintree.new(5)}
  end

  test "filter bintree" do
    tree =
      Bintree.new(1, &(&1 + 1), &(&1 + 2), 2)
      |> Bintree.filter(&(&1 != 3))

    assert tree == %Bintree{value: 1, left: Bintree.new(2)}
  end
end
