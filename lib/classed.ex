defmodule Classed do
  def assign(classified, name) do
    Nameparts.new(name)
    |> do_assign(classified)
  end

  defp do_assign(%Nameparts{} = nameparts, classified) do
    do_assign(nameparts, [], classified)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, []) do
    first_name = Enum.at(kept, 0)
    {middle_name, last_name} = Enum.drop(kept, 1) |> get_middle_last()
    %{nameparts | first_name: first_name, middle_name: middle_name, last_name: last_name}
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "non_name"} | tail]) do
    {full_alias, new_tail} = AliasParts.handle("non_name", tail)
    do_assign_alias(nameparts, kept, full_alias, new_tail)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "begin" <> _} | _] = classified) do
    {full_alias, new_tail} = AliasParts.handle("quoted", classified)
    do_assign_alias(nameparts, kept, full_alias, new_tail)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "the"} | tail]) do
    do_assign(nameparts, kept, tail)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "ln_prefix", index: 0} = head | tail]) do
    new_kept = kept ++ [head.content]
    do_assign(nameparts, new_kept, tail)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "ln_prefix"} = head | [first | rest]]) do
    new_kept = kept ++ ["#{head.content} #{first.content}"]
    do_assign(%{nameparts | has_ln_prefix: true}, new_kept, rest)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "corp_entity"} = head | tail]) do
    new_kept = kept ++ [head.content]
    do_assign(%{nameparts | has_corporate_entity: true}, new_kept, tail)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "supplemental"} | tail]) do
    do_assign(%{nameparts | has_supplemental_info: true}, kept, tail)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "salutation"} = head | tail]) do
    do_assign(%{nameparts | salutation: head.content}, kept, tail)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "generation"} = head | tail]) do
    do_assign(%{nameparts | generation: head.content}, kept, tail)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [%{type: "suffix"} = head | tail]) do
    do_assign(%{nameparts | suffix: head.content}, kept, tail)
  end

  defp do_assign(%Nameparts{} = nameparts, kept, [head | tail]) do
    new_kept = kept ++ [head.content]
    do_assign(nameparts, new_kept, tail)
  end

  defp do_assign_alias(%Nameparts{} = nameparts, kept, full_alias, new_tail) do
    new_aliases = add_alias(nameparts.aliases, full_alias)
    new_nameparts = %{nameparts | has_non_name: true, aliases: new_aliases}
    do_assign(new_nameparts, kept, new_tail)
  end

  defp get_middle_last(name_pieces) do
    do_get_middle_last(name_pieces, [])
  end

  defp do_get_middle_last([], []), do: {nil, nil}

  defp do_get_middle_last([head | []], []), do: {nil, head}

  defp do_get_middle_last([head | []], middle) do
    {Enum.join(middle, " "), head}
  end

  defp do_get_middle_last([head | tail], middle) do
    do_get_middle_last(tail, middle ++ [head])
  end

  defp add_alias(nil, a), do: [a]
  defp add_alias(aliases, a), do: aliases ++ [a]
end
