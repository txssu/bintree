defmodule Bintree.Utils do
  @moduledoc """
  Additional features that might be useful to someone
  """
  @type bintree :: Bintree.bintree()
  @type branch :: Bintree.branch()

  @type table :: :ets.tid()

  @doc """
  Removes branches with duplicate values
  """
  @doc since: "1.0.0"
  @spec remove_duplicates(bintree) :: bintree
  def remove_duplicates(tree) do
    table = :ets.new(:filtering_duplicates, [])
    result = do_remove_duplicates(tree, table)
    :ets.delete(table)
    result
  end

  @spec do_remove_duplicates(branch, :ets.tid()) :: branch
  defp do_remove_duplicates(nil, _table), do: nil

  defp do_remove_duplicates({value, {left, right}}, table) do
    if :ets.insert_new(table, {value}) do
      left = do_remove_duplicates(left, table)
      right = do_remove_duplicates(right, table)
      Bintree.new(value, left, right)
    else
      nil
    end
  end
end
