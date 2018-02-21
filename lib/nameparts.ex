defmodule Nameparts do
  @moduledoc """
  Documentation for nameparts.
  """
  @enforce_keys [:full_name]

  defstruct [
    :full_name,
    :salutation,
    :first_name,
    :middle_name,
    :last_name,
    :generation,
    :suffix,
    :aliases,
    has_corporate_entity: false,
    has_non_name: false,
    has_ln_prefix: false,
    has_supplemental_info: false
  ]

  @salutations [
    "MR", "MS", "MRS", "DR", "MISS", "DOCTOR", "CORP", "SGT", "PVT", "JUDGE",
    "CAPT", "COL", "MAJ", "LT", "LIEUTENANT", "PRM", "PATROLMAN", "HON",
    "OFFICER", "REV", "PRES", "PRESIDENT", "GOV", "GOVERNOR", "VICE PRESIDENT",
    "VP", "MAYOR", "SIR", "MADAM", "HONERABLE"
  ]

  @generations [
    "JR", "SR", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X",
    "1ST", "2ND", "3RD", "4TH", "5TH", "6TH", "7TH", "8TH", "9TH", "10TH",
    "FIRST", "SECOND", "THIRD", "FOURTH", "FIFTH", "SIXTH", "SEVENTH",
    "EIGHTH", "NINTH", "TENTH"
  ]

  @suffixes ["ESQ", "PHD", "MD"]

  @ln_prefixes [
    "DE", "DA", "DI", "LA", "DU", "DEL", "DEI", "VDA", "DELLO", "DELLA",
    "DEGLI", "DELLE", "VAN", "VON", "DER", "DEN", "HEER", "TEN", "TER",
    "VANDE", "VANDEN", "VANDER", "VOOR", "VER", "AAN", "MC", "BEN", "SAN",
    "SAINZ", "BIN", "LI", "LE", "DES", "AM", "AUS'M", "VOM", "ZUM", "ZUR",
    "TEN", "IBN"
  ]

  @non_name ["AKA", "FKA", "NKA", "FICTITIOUS"]

  @corp_entity [
    "NA", "CORP", "CO", "INC", "ASSOCIATES", "SERVICE", "LLC", "LLP", "PARTNERS",
    "RA", "CO", "COUNTY", "STATE", "BANK", "GROUP", "MUTUAL", "FARGO"
  ]

  @supplemental_info ["WIFE OF", "HUSBAND OF", "SON OF", "DAUGHTER OF", "DECEASED"]

  @doc """
  Parse a full name string into its individual parts.

  ## Examples

      iex> {:ok, parts} = Nameparts.parse("Bruce Wayne a/k/a Batman")
      iex> parts.first_name
      "Bruce"
      iex> parts.last_name
      "Wayne"
      iex> parts.aliases |> Enum.at(0)
      "Batman"
      iex> parts.salutation
      nil
      iex> parts.has_non_name
      true
      iex> parts.has_corporate_entity
      false

  """
  def parse(name) when is_binary(name) do
    name_pieces =
      modify_name(name)
      |> String.split(" ")
      |> Enum.with_index()

    output =
      {%Nameparts{full_name: name}, name_pieces}
      |> determine_parts(name_pieces)

    {:ok, output}
  end

  def parse(_), do: {:error, "must be string"}

  # remove unwanted chars and consecutive spaces
  defp modify_name(name) do
    name = Regex.replace(~r/[.,\/\\]/, name, "")
    Regex.replace(~r/\s\s+/, name, " ")
  end

  defp determine_parts({%Nameparts{} = output, name_pieces}, []) do
    name_pieces =
      Enum.filter(name_pieces, fn {str, _} -> String.trim(str) != "" end)
      |> Enum.map(fn {str, _} -> str end)

    first_name = Enum.at(name_pieces, 0)
    {middle_name, last_name} = Enum.drop(name_pieces, 1) |> get_middle_last()

    %{output | first_name: first_name, middle_name: middle_name, last_name: last_name}
  end

  defp determine_parts({%Nameparts{} = output, name_pieces}, [head | tail]) do
    case determine_part(output, head) do
      {output, {:remove, index}} ->
        new_pieces = clear_by_index(name_pieces, index)
        determine_parts({output, new_pieces}, tail)

      {output, {:concat_next, index}} ->
        [_ | new_tail] = tail
        new_pieces = concat_next(name_pieces, index, 1)
        determine_parts({output, new_pieces}, new_tail)

      {output, {:handle_alias, quote_type, index}} ->
        {new_output, new_pieces, new_tail} =
          handle_alias({output, name_pieces}, index, {quote_type, tail})

        determine_parts({new_output, new_pieces}, new_tail)

      {output, :keep} ->
        determine_parts({output, name_pieces}, tail)
    end
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

  defp determine_part(%Nameparts{} = output, {name_piece, index}) do
    cond do
      # ignore "the"
      String.downcase(name_piece) == "the" ->
        {output, {:remove, index}}

      # salutation?
      is_nil(output.salutation) and is_in_list?(@salutations, name_piece) ->
        {%{output | salutation: name_piece}, {:remove, index}}

      # generation?
      is_nil(output.generation) and is_in_list?(@generations, name_piece) ->
        {%{output | generation: name_piece}, {:remove, index}}

      # suffix?
      is_nil(output.suffix) and is_in_list?(@suffixes, name_piece) ->
        {%{output | suffix: name_piece}, {:remove, index}}

      # has LN prefix?
      not output.has_ln_prefix and is_in_list?(@ln_prefixes, name_piece) and index != 0 ->
        {%{output | has_ln_prefix: true}, {:concat_next, index}}

      # alias?
      is_in_list?(@non_name, name_piece) ->
        {%{output | has_non_name: true}, {:handle_alias, :non_quote, index}}

      # quoted alias?
      String.first(name_piece) == "'" ->
        {%{output | has_non_name: true}, {:handle_alias, :single_quote, index}}

      String.first(name_piece) == "\"" ->
        {%{output | has_non_name: true}, {:handle_alias, :double_quote, index}}

      # has corporate entity?
      not output.has_corporate_entity and is_in_list?(@corp_entity, name_piece) ->
        {%{output | has_corporate_entity: true}, :keep}

      # has supplemental info?
      not output.has_supplemental_info and is_in_list?(@supplemental_info, name_piece) ->
        {%{output | has_supplemental_info: true}, {:remove, index}}

      # everything else
        true -> {output, :keep}
    end
  end

  defp is_in_list?(list_attr, name_piece) do
    upper = String.upcase(name_piece)
    Enum.member?(list_attr, upper)
  end

  defp clear_by_index(name_pieces, index) do
    name_pieces
    |> Enum.map(fn {_, v} = existing ->
      cond do
        v == index -> {"", v}
        true -> existing
      end
    end)
  end

  defp concat_next(name_pieces, index, concat_count) do
    last_id = index + concat_count

    new_str =
      Enum.slice(name_pieces, index..last_id)
      |> Enum.map(fn {k, _} -> k end)
      |> Enum.join(" ")

    name_pieces
    |> Enum.map(fn {_, v} = existing ->
      cond do
        v < index -> existing
        v == index -> {new_str, v}
        v <= last_id -> {"", v}
        true -> existing
      end
    end)
  end

  defp handle_alias({output, name_pieces}, index, {quote_type, remaining_pieces}) do
    count = count_alias({quote_type, remaining_pieces})
    new_tail = Enum.drop(remaining_pieces, count)
    {new_output, new_pieces} = get_alias_output(output, name_pieces, {index, count, quote_type})

    {new_output, new_pieces, new_tail}
  end

  defp count_alias({:non_quote, [{str, _} | _]}) do
    case String.downcase(str) do
      "the" -> 2
      _ -> 0
    end
  end

  defp count_alias({:double_quote, remaining_pieces}) do
    do_count_alias("\"", remaining_pieces, 0)
  end

  defp count_alias({:single_quote, remaining_pieces}) do
    do_count_alias("'", remaining_pieces, 0)
  end

  defp do_count_alias(_, [], _), do: 0

  defp do_count_alias(quo, [{str, _} | tail], num) do
    case String.ends_with?(str, quo) do
      false -> do_count_alias(quo, tail, num + 1)
      true -> num + 1
    end
  end

  defp get_alias_output(output, name_pieces, {index, count, :non_quote}) do
    name_pieces =
      case count do
        0 ->
          clear_by_index(name_pieces, index)

        2 ->
          clear_by_index(name_pieces, index)
          |> concat_next(index + 1, 1)
      end

    {a, _} = Enum.at(name_pieces, index + 1)
    new_pieces = clear_by_index(name_pieces, index + 1)
    new_aliases = add_alias(output.aliases, a)

    {%{output | aliases: new_aliases}, new_pieces}
  end

  defp get_alias_output(output, name_pieces, {index, count, _}) do
    name_pieces = concat_next(name_pieces, index, count)
    {a, _} = Enum.at(name_pieces, index)
    a = a |> String.trim("'") |> String.trim("\"")
    new_pieces = clear_by_index(name_pieces, index)
    new_aliases = add_alias(output.aliases, a)

    {%{output | aliases: new_aliases}, new_pieces}
  end

  defp add_alias(aliases, a) do
    case is_nil(aliases) do
      true -> [a]
      false -> aliases ++ [a]
    end
  end
end
