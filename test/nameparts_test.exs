defmodule NamepartsTest do
  use ExUnit.Case
  doctest Nameparts

  test "does not parse a non-string" do
    assert {:error, "must be string"} = Nameparts.parse(3)
    assert {:error, "must be string"} = Nameparts.parse(["j"])
    assert {:error, "must be string"} = Nameparts.parse(:ok)
    assert {:error, "must be string"} = Nameparts.parse({:ok, "yay"})
    assert {:error, "must be string"} = Nameparts.parse(Date.utc_today())
  end

  test "returns a Nameparts struct" do
    {:ok, name_parts} = Nameparts.parse("John")
    assert name_parts == %Nameparts{full_name: "John", first_name: "John"}
  end

  test "parses a simple name" do
    {:ok, name_parts} = Nameparts.parse("John Jacob")

    # Parse results
    assert name_parts.full_name == "John Jacob"
    assert name_parts.first_name == "John"
    assert name_parts.last_name == "Jacob"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)
    assert is_nil(name_parts.aliases)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_non_name == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a simple name, whose first name matches a LN Prefix" do
    {:ok, name_parts} = Nameparts.parse("Ben Franklin")

    # Parse results
    assert name_parts.full_name == "Ben Franklin"
    assert name_parts.first_name == "Ben"
    assert name_parts.last_name == "Franklin"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)
    assert is_nil(name_parts.aliases)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_non_name == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a simple name with a single middle name" do
    {:ok, name_parts} = Nameparts.parse("Neil Patrick Harris")

    # Parse results
    assert name_parts.full_name == "Neil Patrick Harris"
    assert name_parts.first_name == "Neil"
    assert name_parts.middle_name == "Patrick"
    assert name_parts.last_name == "Harris"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)
    assert is_nil(name_parts.aliases)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_non_name == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a spaced surname" do
    {:ok, name_parts} = Nameparts.parse("Otto Von Bismark")

    # Parse results
    assert name_parts.full_name == "Otto Von Bismark"
    assert name_parts.first_name == "Otto"
    assert name_parts.last_name == "Von Bismark"
    assert name_parts.has_ln_prefix == true

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)
    assert is_nil(name_parts.aliases)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_non_name == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses an apostrophe surname" do
    {:ok, name_parts} = Nameparts.parse("Scarlett O'Hara")

    # Parse results
    assert name_parts.full_name == "Scarlett O'Hara"
    assert name_parts.first_name == "Scarlett"
    assert name_parts.last_name == "O'Hara"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)
    assert is_nil(name_parts.aliases)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_non_name == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a generation name" do
    {:ok, name_parts} = Nameparts.parse("Thurston Howell III")

    # Parse results
    assert name_parts.full_name == "Thurston Howell III"
    assert name_parts.first_name == "Thurston"
    assert name_parts.last_name == "Howell"
    assert name_parts.generation == "III"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.suffix)
    assert is_nil(name_parts.aliases)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_non_name == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a generation name designated by the word 'the'" do
    {:ok, name_parts} = Nameparts.parse("Thurston Howell the 3rd")

    # Parse results
    assert name_parts.full_name == "Thurston Howell the 3rd"
    assert name_parts.first_name == "Thurston"
    assert name_parts.last_name == "Howell"
    assert name_parts.generation == "3rd"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.suffix)
    assert is_nil(name_parts.aliases)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_non_name == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a generation name designated by the spelled out word" do
    {:ok, name_parts} = Nameparts.parse("Thurston Howell Third")

    # Parse results
    assert name_parts.full_name == "Thurston Howell Third"
    assert name_parts.first_name == "Thurston"
    assert name_parts.last_name == "Howell"
    assert name_parts.generation == "Third"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.suffix)
    assert is_nil(name_parts.aliases)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_non_name == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a generation name designated by the word 'the' and the spelled out generation" do
    {:ok, name_parts} = Nameparts.parse("Thurston Howell the Third")

    # Parse results
    assert name_parts.full_name == "Thurston Howell the Third"
    assert name_parts.first_name == "Thurston"
    assert name_parts.last_name == "Howell"
    assert name_parts.generation == "Third"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.suffix)
    assert is_nil(name_parts.aliases)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_non_name == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a single alias name" do
    {:ok, name_parts} = Nameparts.parse("Bruce Wayne a/k/a Batman")

    # Parse results
    assert name_parts.full_name == "Bruce Wayne a/k/a Batman"
    assert name_parts.first_name == "Bruce"
    assert name_parts.last_name == "Wayne"
    assert name_parts.has_non_name == true
    assert name_parts.aliases |> Enum.at(0) == "Batman"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a nickname with one word" do
    {:ok, name_parts} = Nameparts.parse("\"Stonecold\" Steve Austin")

    # Parse results
    assert name_parts.full_name == "\"Stonecold\" Steve Austin"
    assert name_parts.first_name == "Steve"
    assert name_parts.last_name == "Austin"
    assert name_parts.has_non_name == true
    assert name_parts.aliases |> Enum.at(0) == "Stonecold"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a nickname with two words" do
    {:ok, name_parts} = Nameparts.parse("Dwayne \"The Rock\" Johnson")

    # Parse results
    assert name_parts.full_name == "Dwayne \"The Rock\" Johnson"
    assert name_parts.first_name == "Dwayne"
    assert name_parts.last_name == "Johnson"
    assert name_parts.has_non_name == true
    assert name_parts.aliases |> Enum.at(0) == "The Rock"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a nickname using single quotes" do
    {:ok, name_parts} = Nameparts.parse("O'Shea 'Ice Cube' Jackson")

    # Parse results
    assert name_parts.full_name == "O'Shea 'Ice Cube' Jackson"
    assert name_parts.first_name == "O'Shea"
    assert name_parts.last_name == "Jackson"
    assert name_parts.has_non_name == true
    assert name_parts.aliases |> Enum.at(0) == "Ice Cube"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses a nick name with many spaces" do
    {:ok, name_parts} = Nameparts.parse("\"The Nature Boy\" Ric Flair")

    # Parse results
    assert name_parts.full_name == "\"The Nature Boy\" Ric Flair"
    assert name_parts.first_name == "Ric"
    assert name_parts.last_name == "Flair"
    assert name_parts.has_non_name == true
    assert name_parts.aliases |> Enum.at(0) == "The Nature Boy"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses multiple aliases" do
    {:ok, name_parts} =
      Nameparts.parse(
        "\"The People's Champion\" Mohammed \"Louisville Lip\" Ali aka The Greatest"
      )

    # Parse results
    assert name_parts.full_name ==
             "\"The People's Champion\" Mohammed \"Louisville Lip\" Ali aka The Greatest"

    assert name_parts.first_name == "Mohammed"
    assert name_parts.last_name == "Ali"
    assert name_parts.has_non_name == true
    assert name_parts.aliases |> Enum.at(0) == "The People's Champion"
    assert name_parts.aliases |> Enum.at(1) == "Louisville Lip"
    assert name_parts.aliases |> Enum.at(2) == "The Greatest"

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.middle_name)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_ln_prefix == false
    assert name_parts.has_supplemental_info == false
  end

  test "parses supplemental information" do
    {:ok, name_parts} = Nameparts.parse("Philip Francis \"The Scooter\" Rizzuto, deceased")

    # Parse results
    assert name_parts.full_name == "Philip Francis \"The Scooter\" Rizzuto, deceased"
    assert name_parts.first_name == "Philip"
    assert name_parts.middle_name == "Francis"
    assert name_parts.last_name == "Rizzuto"
    assert name_parts.has_non_name == true
    assert name_parts.aliases |> Enum.at(0) == "The Scooter"
    assert name_parts.has_supplemental_info == true

    # Members not used for this result
    assert is_nil(name_parts.salutation)
    assert is_nil(name_parts.generation)
    assert is_nil(name_parts.suffix)

    # Flags
    assert name_parts.has_corporate_entity == false
    assert name_parts.has_ln_prefix == false
  end

  test "parses a name with multiple middle names" do
    {:ok, name_parts} = Nameparts.parse("George Herbert Walker Bush")
    assert name_parts.first_name == "George"
    assert name_parts.middle_name == "Herbert Walker"
    assert name_parts.last_name == "Bush"
  end
end
