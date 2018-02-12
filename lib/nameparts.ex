defmodule Nameparts do
  @moduledoc """
  Documentation for Nameparts.
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
    :has_corporate_entity,
    :has_non_name,
    :has_ln_prefix,
    :has_supplemental_info
  ]

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
