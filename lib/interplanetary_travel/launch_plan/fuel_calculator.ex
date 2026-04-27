defmodule InterplanetaryTravel.LaunchPlan.FuelCalculator do
  @moduledoc """
  Provides functions to calculate the fuel requirements for interplanetary travel based on mass and gravitational acceleration.
  """

  @doc """
  Calculates the total fuel required for a given operation (launch or landing),
  accounting for the weight of the fuel itself. Recursively adds fuel for each
  fuel load until no additional fuel is needed.

  Accepts either `:launch` or `:land` as the operation type. Returns 0 for any
  other operation type.

  ## Examples

      iex> InterplanetaryTravel.LaunchPlan.FuelCalculator.calculate(:launch, 28_801, 9.807)
      19772

      iex> InterplanetaryTravel.LaunchPlan.FuelCalculator.calculate(:land, 28_801, 9.807)
      13447

      iex> InterplanetaryTravel.LaunchPlan.FuelCalculator.calculate(:unknown, 28_801, 9.807)
      0
  """
  @spec calculate(atom(), integer(), float()) :: integer()
  def calculate(:launch, mass, gravity), do: accumulate_fuel(&launch/2, mass, gravity, 0)
  def calculate(:land, mass, gravity), do: accumulate_fuel(&landing/2, mass, gravity, 0)
  def calculate(_, _, _), do: 0

  @doc """
  Calculates the fuel required for a launch given a mass and gravitational acceleration.

  ## Examples

      iex> InterplanetaryTravel.LaunchPlan.FuelCalculator.launch(28_801, 9.807)
      11829
  """
  @spec launch(integer(), float()) :: integer()
  def launch(mass, gravity), do: calculate_fuel(mass, gravity, 0.042, 33)

  @doc """
  Calculates the fuel required for a landing given a mass and gravitational acceleration.

  ## Examples

      iex> InterplanetaryTravel.LaunchPlan.FuelCalculator.landing(28_801, 9.807)
      9278
  """
  @spec landing(integer(), float()) :: integer()
  def landing(mass, gravity), do: calculate_fuel(mass, gravity, 0.033, 42)

  defp accumulate_fuel(fuel_fn, mass, gravity, acc) do
    fuel = fuel_fn.(mass, gravity)

    if fuel <= 0 do
      acc
    else
      accumulate_fuel(fuel_fn, fuel, gravity, acc + fuel)
    end
  end

  defp calculate_fuel(mass, gravity, factor, offset) do
    floor(mass * gravity * factor - offset)
  end
end
