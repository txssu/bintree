defmodule Bintree.Utils do
  @moduledoc """
  Additional features that might be useful to someone
  """

  @doc """
  Removes branches with duplicate values
  """
  @doc since: "1.0.0"
  @spec remove_duplicates(Bintree.t()) :: Bintree.t()
  def remove_duplicates(tree) do
    {result, _} = do_remove_duplicates(tree, Map.new())

    result
  end

  @spec do_remove_duplicates(Bintree.t() | nil, map) :: {Bintree.t() | nil, map}
  defp do_remove_duplicates(nil, finded), do: {nil, finded}

  defp do_remove_duplicates(tree, finded) do
    case Map.fetch(finded, tree.value) do
      {:ok, _} ->
        {nil, finded}
      :error ->
        finded = Map.put_new(finded, tree.value, 0)
        {left, finded} = do_remove_duplicates(tree.left, finded)
        {right, finded} = do_remove_duplicates(tree.right, finded)
        {Bintree.new(tree.value, left, right), finded}
    end
  end
end
