defmodule BintreeDisplayTest do
  use ExUnit.Case

  test "straight tree to string" do
    tree = Bintree.new(1, Bintree.new(2, nil, 3))

    assert to_string(tree) == "1\n|\n2\n|\n3"
  end

  test "straight tree but elements with odd length" do
    tree = Bintree.new(1, Bintree.new(20, nil, 3))

    assert to_string(tree) == " 1 \n | \n20 \n | \n 3 "
  end

  test "tree that splits" do
    tree = Bintree.new(1, 2, 3)

    assert to_string(tree) == " 1 \n | \n/-\\\n| |\n2 3"
  end

  test "tree that splits and elements with odd length" do
    tree = Bintree.new(1, Bintree.new(20, 3), Bintree.new(4, 50))

    assert to_string(tree) == "   1   \n   |   \n /---\\ \n |   | \n20   4 \n |   | \n 3  50 "
  end
end
