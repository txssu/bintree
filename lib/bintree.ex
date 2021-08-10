defmodule Bintree do
  @moduledoc """
  Basic module
  """
  defstruct value: nil, left: nil, right: nil

  @typedoc """
  Binary tree where branches can be nil
  """
  @type t :: %Bintree{value: any, left: t | nil, right: t | nil}

  @type filter_fun :: (any -> boolean)
  @type process_fun :: (any -> any)

  @doc """
  Creates base binary tree
  """
  @doc since: "1.0.0"
  @spec new(any, t | nil, t | nil) :: t
  def new(value, left \\ nil, right \\ nil) do
    left =
      if branch?(left) do
        left
      else
        new(left)
      end

    right =
      if branch?(right) do
        right
      else
        new(right)
      end

    %Bintree{value: value, left: left, right: right}
  end

  defp branch?(nil), do: true

  defp branch?(%Bintree{}), do: true

  defp branch?(_other), do: false

  @doc """
  Automatically generates binary tree values

  Generates a branch while the filter_fun returns a truthy value.

  ## Examples
      iex> Bintree.new(1, &(&1*3), &(&1+3), &(&1 > 10))

  Returns a binary tree, where turning left is multiplying by three,
  turning right is adding three. If the number is greater than 10,
  then the generation of this branch is stopped.

      iex> Bintree.new(1, &(&1*3), &(&1+3), 4)

  The rules are the same as the previous one, but the generation of the tree will end
  when the depth of 4 values is reached.
  """
  @doc since: "1.0.0"
  @spec new(any, process_fun, process_fun, filter_fun | non_neg_integer()) :: t | nil
  def new(value, left_fun, right_fun, filter_fun) when is_function(filter_fun) do
    if filter_fun.(value) do
      left = new(left_fun.(value), left_fun, right_fun, filter_fun)
      right = new(right_fun.(value), left_fun, right_fun, filter_fun)

      new(value, left, right)
    else
      nil
    end
  end

  def new(_value, _left_fun, _right_fun, 0), do: nil

  def new(value, left_fun, right_fun, depth) when is_integer(depth) do
    left = new(left_fun.(value), left_fun, right_fun, depth - 1)
    right = new(right_fun.(value), left_fun, right_fun, depth - 1)

    new(value, left, right)
  end

  @doc """
  Inserts a `value` at a given `path`

  ## Example
      iex> Bintree.new(1, 3, 5)
      iex> |> Bintree.insert([:left, :left], 5)
      iex> |> Bintree.insert([:left, :right], 28)

      # Result:
      #     1
      #     |
      #    /---\\
      #    |   |
      #    3   5
      #    |
      #  /--\\
      #  |  |
      #  5 28

  """
  @doc since: "1.1.1"
  @spec insert(t, [:left | :right, ...], any) :: t
  def insert(tree, path, value)

  def insert(nil, [], value), do: new(value)

  def insert(tree, [], value), do: %{tree | value: value}

  def insert(%Bintree{value: v, left: left, right: right}, [head | tail], value) do
    case head do
      :left ->
        new(v, insert(left, tail, value), right)

      :right ->
        new(v, left, insert(right, tail, value))
    end
  end

  @doc """
  Filters the `bintree`, i.e. returns only those branch for which `filter_fun` returns a truthy value.
  """
  @doc since: "1.0.0"
  @spec filter(t | nil, filter_fun) :: t | nil
  def filter(tree, filter_fun)

  def filter(%Bintree{value: v, left: l, right: r}, filter_fun) do
    if filter_fun.(v) do
      left = filter(l, filter_fun)
      right = filter(r, filter_fun)

      new(v, left, right)
    else
      nil
    end
  end

  def filter(nil, _fun), do: nil
end

defimpl String.Chars, for: Bintree do

  @spec to_string(Bintree.t()) :: String.t()
  def to_string(tree) do
    Bintree.Display.format(tree)
  end
end
