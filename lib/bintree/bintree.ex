defmodule Bintree do
  @type value :: integer
  @type bintree :: {value, {branch, branch}}
  @type branch :: bintree | nil

  @type filter_fun :: (value -> boolean)
  @type process_fun :: (value -> value)

  @spec new(any, branch, branch) :: bintree
  def new(value, left \\ nil, right \\ nil) do
    {value, {left, right}}
  end

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

  @spec to_string(bintree) :: String.t()
  def to_string(tree) do
    Bintree.Display.format(tree)
  end

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
