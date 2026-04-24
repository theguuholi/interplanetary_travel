defmodule InterplanetaryTravel.LaunchPlan do
  @moduledoc """
  Provides functions to calculate the fuel requirements for interplanetary travel based on mass and planet.
  """

  alias __MODULE__.FuelCalculator

  @available_planets %{
    earth: 9.807,
    moon: 1.62,
    mars: 3.71
  }

  @doc """
  Calculates the fuel required for a launch given a mass and planet. Returns an error if the planet is not available.

  ## Examples

      iex> InterplanetaryTravel.LaunchPlan.launch(28_801, :earth)
      {:ok, 19772}

      iex> InterplanetaryTravel.LaunchPlan.launch(28_801, :pluto)
      {:error, :planet_is_not_available}
  """
  @spec launch(integer(), atom()) :: {:ok, integer()} | {:error, :planet_is_not_available}
  def launch(mass, planet) do
    gravity = Map.get(@available_planets, planet)

    case gravity do
      nil -> {:error, :planet_is_not_available}
      gravity -> {:ok, FuelCalculator.total_launch_fuel(mass, gravity)}
    end
  end

  @doc """
  Calculates the fuel required for a landing given a mass and planet. Returns an error if the planet is not available.

  ## Examples

      iex> InterplanetaryTravel.LaunchPlan.landing(28_801, :earth)
      {:ok, 13447}

      iex> InterplanetaryTravel.LaunchPlan.landing(28_801, :pluto)
      {:error, :planet_is_not_available}
  """
  def landing(mass, planet) do
    gravity = Map.get(@available_planets, planet)

    case gravity do
      nil -> {:error, :planet_is_not_available}
      gravity -> {:ok, FuelCalculator.total_landing_fuel(mass, gravity)}
    end
  end
end
