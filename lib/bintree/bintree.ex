defmodule Bintree do
  @moduledoc """
  Basic module
  """
  @typedoc """
  Currently only integers are supported as a value
  """
  @type value :: integer
  @typedoc """
  Binary tree with left and right branch
  """
  @type bintree :: {value, {branch, branch}}
  @typedoc """
  Branch can be nil or other bintree
  """
  @type branch :: bintree | nil

  @type filter_fun :: (value -> boolean)
  @type process_fun :: (value -> value)

  @doc """
  Creates base binary tree
  """
  @doc since: "1.0.0"
  @spec new(any, branch, branch) :: bintree
  def new(value, left \\ nil, right \\ nil) do
    {value, {left, right}}
  end

  @doc """
  Automatically generates binary tree values

  Stops if `stop_fun` returns `true` or if it reaches a certain `depth`

  ## Examples
      iex> Bintree.new(1, &(&1*3), &(&1+3), &(&1 > 10))
      # Returns a binary tree, where turning left is multiplying by three,
      # turning right is adding three. If the number is greater than 10,
      # then the generation of this branch is stopped.

      iex> Bintree.new(1, &(&1*3), &(&1+3), 4)
      # The rules are the same as the previous one, but the generation of the tree will end
      # when the depth of 4 values is reached.
  """
  @doc since: "1.0.0"
  @spec new(any, process_fun, process_fun, filter_fun | non_neg_integer()) :: branch
  def new(value, left_fun, right_fun, stop_fun) when is_function(stop_fun) do
    if stop_fun.(value) do
      nil
    else
      left = new(left_fun.(value), left_fun, right_fun, stop_fun)
      right = new(right_fun.(value), left_fun, right_fun, stop_fun)

      {value, {left, right}}
    end
  end

  def new(_value, _left_fun, _right_fun, 0), do: nil

  def new(value, left_fun, right_fun, depth) when is_integer(depth) do
    left = new(left_fun.(value), left_fun, right_fun, depth - 1)
    right = new(right_fun.(value), left_fun, right_fun, depth - 1)

    {value, {left, right}}
  end

  @doc """
  Formats the type of a binary tree to a string
  """
  @doc since: "1.0.0"
  @spec to_string(bintree) :: String.t()
  def to_string(tree) do
    Bintree.Display.format(tree)
  end

  @doc """
  Filters the `bintree`, i.e. returns only those branch for which `filter_fun` returns a truthy value.
  """
  @doc since: "1.0.0"
  @spec filter(branch, filter_fun) :: branch
  def filter(tree, filter_fun)

  def filter({value, {left, right}}, filter_fun) do
    if filter_fun.(value) do
      left = filter(left, filter_fun)
      right = filter(right, filter_fun)
      {value, {left, right}}
    else
      nil
    end
  end

  def filter(nil, _fun), do: nil
end
