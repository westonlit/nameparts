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
    output = do_parse(name)
    {:ok, output}
  end

  def parse(_), do: {:error, "must be a string"}

  defp do_parse(name) do
    get_name_pieces(name)
    |> Parts.classify()
    |> Classed.assign(name)
  end

  defp get_name_pieces(name) do
    modify_name(name)
    |> String.split(" ")
    |> Enum.with_index()
  end

  # remove unwanted chars and consecutive spaces
  defp modify_name(name) do
    name = Regex.replace(~r/[.,\/\\]/, name, "")
    Regex.replace(~r/\s\s+/, name, " ")
  end

  def new(name), do: %Nameparts{full_name: name}
end
