defmodule AliasParts do
  def handle("non_name", [%{type: "the"} = first | rest]) do
    [head | tail] = rest
    {"#{first.content} #{head.content}", tail}
  end

  def handle("non_name", [head | tail]) do
    {head.content, tail}
  end

  def handle("quoted", [%{type: "begin_end"} = head | tail]) do
    full_alias = trim_quotes(head.content)
    {full_alias, tail}
  end

  def handle("quoted", [%{type: "begin_" <> begin_type} | _] = classified) do
    concat_alias(begin_type, classified)
  end

  defp concat_alias(type, [%{type: "begin" <> _} = head | tail]) do
    do_concat_alias(type, [head.content], tail)
  end

  defp do_concat_alias(type, alias_parts, [%{type: "end_" <> end_type} = head | tail]) do
    new_parts = Enum.concat(alias_parts, [head.content])
    do_concat_alias(type, new_parts, tail, type == end_type)
  end

  # edge case, when the quote is unclosed
  defp do_concat_alias(_, alias_parts, [head | []]) do
    new_parts = Enum.concat(alias_parts, [head.content])
    full_alias = new_parts |> Enum.join(" ") |> trim_quotes()
    {full_alias, []}
  end

  defp do_concat_alias(type, alias_parts, [head | tail]) do
    new_parts = Enum.concat(alias_parts, [head.content])
    do_concat_alias(type, new_parts, tail)
  end

  defp do_concat_alias(_, alias_parts, remaining, true) do
    full_alias = alias_parts |> Enum.join(" ") |> trim_quotes()
    {full_alias, remaining}
  end

  defp do_concat_alias(type, alias_parts, remaining, false) do
    do_concat_alias(type, alias_parts, remaining)
  end

  defp trim_quotes(full_quote) do
    full_quote
    |> String.trim("'")
    |> String.trim("\"")
  end
end