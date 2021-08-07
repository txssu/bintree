defmodule Bintree.Display do
  @moduledoc false

  alias Markex.Element
  import Markex.Element.Operators

  @type bintree :: Bintree.bintree()
  @type branch :: Bintree.branch()
  @type element :: Markex.Element.element()

  @space Element.new(" ")
  @down Element.new("|")
  @left Element.new("/")
  @right Element.new("\\")

  @spec format(bintree) :: String.t()
  def format(tree) do
    do_format(tree)
    |> Element.to_string()
  end

  @spec do_format(bintree) :: element
  defp do_format({num, {left, right}}) do
    len = length(Integer.digits(num))

    num_for_elem =
      Integer.to_string(num) <>
        if rem(len, 2) == 0 do
          " "
        else
          ""
        end

    case {is_nil(left), is_nil(right)} do
      {true, true} -> Element.new(num_for_elem)
      {false, true} -> Element.new(num_for_elem) <~> @down <~> do_format(left)
      {true, false} -> Element.new(num_for_elem) <~> @down <~> do_format(right)
      {false, false} -> Element.new(num_for_elem) <~> @down <~> do_format_div(left, right)
    end
  end

  @spec do_format_div(bintree, bintree) :: element
  defp do_format_div(left, right) do
    columns =
      [left, right] = [
        @down <~> do_format(left),
        @down <~> do_format(right)
      ]

    elem =
      left
      |> Element.beside(@space)
      |> Element.beside(right, :top)

    connector(columns) <~> elem
  end

  @spec bar(String.t(), non_neg_integer()) :: element
  defp bar(symbol, len) do
    Element.new(symbol, len, 1)
  end

  @spec horizontal_bar(non_neg_integer()) :: element
  defp horizontal_bar(len) do
    bar("-", len)
  end

  @spec empty_bar(non_neg_integer()) :: element
  defp empty_bar(len) do
    bar(" ", len)
  end

  @spec connector([element, ...]) :: element
  defp connector([left, right]) do
    left_column_len = Element.width(left)

    half_left_column_len =
      if div(left_column_len, 2) == 1 do
        div(left_column_len - 1, 2)
      else
        div(left_column_len, 2)
      end

    left_connector =
      empty_bar(half_left_column_len)
      <|> @left
      <|> horizontal_bar(half_left_column_len)

    right_column_len = Element.width(right)

    half_right_column_len =
      if div(right_column_len, 2) == 1 do
        div(right_column_len - 1, 2)
      else
        div(right_column_len, 2)
      end

    right_connector =
      horizontal_bar(half_right_column_len)
      <|> @right
      <|> empty_bar(half_right_column_len)

    left_connector <|> horizontal_bar(1) <|> right_connector
  end
end
