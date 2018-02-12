defmodule Nameparts do
  @moduledoc """
  Documentation for Nameparts.
  """
  alias __MODULE__
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
    :has_corporate_entity,
    :has_non_name,
    :has_ln_prefix,
    :has_supplemental_info
  ]

  @salutations = [
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

  @generations = [
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

  @suffixes = ["ESQ", "PHD", "MD"]

  @ln_prefixes = [
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

  @no_name = ["AKA", "FKA", "NKA", "FICTITIOUS"]

  @corp_entity = [
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

  @supplemental_info = ["WIFE OF", "HUSBAND OF", "SON OF", "DAUGHTER OF", "DECEASED"]

  @doc """
  Hello world.

  ## Examples

      iex> Nameparts.hello
      :world

  """
  def hello do
    :world
  end
end
