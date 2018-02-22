defmodule Parts do
  alias __MODULE__

  defstruct [
    :content,
    :index,
    :type,
    :uppercase,
    :lowercase,
    :starts_with,
    :ends_with
  ]

  @type_lists [
    "salutation",
    "generation",
    "suffix",
    "ln_prefix",
    "non_name",
    "corp_entity",
    "supplemental"
  ]

  def classify(name_pieces), do: classify([], name_pieces)

  def classify(classified, []) do
    Enum.map(classified, &cleanup(&1))
  end

  def classify(classified, [head | tail]) do
    checked = new(head) |> classify_part()
    classify(classified ++ [checked], tail)
  end

  defp cleanup(%Parts{} = part) do
    Map.from_struct(part)
    |> trim()
  end

  defp trim(part_map) do
    %{
      content: part_map.content,
      index: part_map.index,
      type: part_map.type
    }
  end

  defp new({name_piece, index}) do
    {lo, up, fi, la} = get_name_piece_data(name_piece)

    %Parts{
      content: name_piece,
      index: index,
      uppercase: up,
      lowercase: lo,
      starts_with: fi,
      ends_with: la
    }
  end

  defp get_name_piece_data(name_piece) do
    {
      String.downcase(name_piece),
      String.upcase(name_piece),
      String.first(name_piece),
      String.last(name_piece)
    }
  end

  defp classify_part(%Parts{type: nil, lowercase: "the"} = part) do
    %{part | type: "the"}
  end

  defp classify_part(%Parts{type: nil, starts_with: "'", ends_with: "'"} = part) do
    %{part | type: "begin_end"}
  end

  defp classify_part(%Parts{type: nil, starts_with: "\"", ends_with: "\""} = part) do
    %{part | type: "begin_end"}
  end

  defp classify_part(%Parts{type: nil, starts_with: "'"} = part) do
    %{part | type: "begin_sq"}
  end

  defp classify_part(%Parts{type: nil, starts_with: "\""} = part) do
    %{part | type: "begin_dq"}
  end

  defp classify_part(%Parts{type: nil, ends_with: "'"} = part) do
    %{part | type: "end_sq"}
  end

  defp classify_part(%Parts{type: nil, ends_with: "\""} = part) do
    %{part | type: "end_dq"}
  end

  defp classify_part(%Parts{type: nil} = part) do
    check_types(part)
  end

  defp check_types(part) do
    Enum.reduce(@type_lists, part, fn x, acc -> check_type(x, acc) end)
  end

  defp check_type(type, part) do
    type_list = get_type_list(type)

    with true <- is_nil(part.type),
         true <- Enum.member?(type_list, part.uppercase) do
      %{part | type: type}
    else
      false -> part
    end
  end

  defp get_type_list("salutation") do
    [
      "MR",
      "MS",
      "MRS",
      "DR",
      "MISS",
      "DOCTOR",
      "CORP",
      "SGT",
      "PVT",
      "JUDGE",
      "CAPT",
      "COL",
      "MAJ",
      "LT",
      "LIEUTENANT",
      "PRM",
      "PATROLMAN",
      "HON",
      "OFFICER",
      "REV",
      "PRES",
      "PRESIDENT",
      "GOV",
      "GOVERNOR",
      "VICE PRESIDENT",
      "VP",
      "MAYOR",
      "SIR",
      "MADAM",
      "HONERABLE"
    ]
  end

  defp get_type_list("generation") do
    [
      "JR",
      "SR",
      "I",
      "II",
      "III",
      "IV",
      "V",
      "VI",
      "VII",
      "VIII",
      "IX",
      "X",
      "1ST",
      "2ND",
      "3RD",
      "4TH",
      "5TH",
      "6TH",
      "7TH",
      "8TH",
      "9TH",
      "10TH",
      "FIRST",
      "SECOND",
      "THIRD",
      "FOURTH",
      "FIFTH",
      "SIXTH",
      "SEVENTH",
      "EIGHTH",
      "NINTH",
      "TENTH"
    ]
  end

  defp get_type_list("suffix") do
    ["ESQ", "PHD", "MD"]
  end

  defp get_type_list("ln_prefix") do
    [
      "DE",
      "DA",
      "DI",
      "LA",
      "DU",
      "DEL",
      "DEI",
      "VDA",
      "DELLO",
      "DELLA",
      "DEGLI",
      "DELLE",
      "VAN",
      "VON",
      "DER",
      "DEN",
      "HEER",
      "TEN",
      "TER",
      "VANDE",
      "VANDEN",
      "VANDER",
      "VOOR",
      "VER",
      "AAN",
      "MC",
      "BEN",
      "SAN",
      "SAINZ",
      "BIN",
      "LI",
      "LE",
      "DES",
      "AM",
      "AUS'M",
      "VOM",
      "ZUM",
      "ZUR",
      "TEN",
      "IBN"
    ]
  end

  defp get_type_list("non_name") do
    ["AKA", "FKA", "NKA", "FICTITIOUS"]
  end

  defp get_type_list("corp_entity") do
    [
      "NA",
      "CORP",
      "CO",
      "INC",
      "ASSOCIATES",
      "SERVICE",
      "LLC",
      "LLP",
      "PARTNERS",
      "RA",
      "CO",
      "COUNTY",
      "STATE",
      "BANK",
      "GROUP",
      "MUTUAL",
      "FARGO"
    ]
  end

  defp get_type_list("supplemental") do
    ["WIFE OF", "HUSBAND OF", "SON OF", "DAUGHTER OF", "DECEASED"]
  end

  defp get_type_list(_), do: []
end
