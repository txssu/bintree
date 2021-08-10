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
    table = :ets.new(:filtering_duplicates, [])
    result = do_remove_duplicates(tree, table)
    :ets.delete(table)
    result
  end

  @spec do_remove_duplicates(Bintree.t() | nil, :ets.tid()) :: Bintree.t() | nil
  defp do_remove_duplicates(nil, _table), do: nil

  defp do_remove_duplicates(%Bintree{value: v, left: l, right: r}, table) do
    if :ets.insert_new(table, {v}) do
      left = do_remove_duplicates(l, table)
      right = do_remove_duplicates(r, table)
      Bintree.new(v, left, right)
    else
      nil
    end
  end
end
