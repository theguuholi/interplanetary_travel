defmodule InterplanetaryTravel.LaunchPlan.FuelCalculator do
  @moduledoc """
  Provides functions to calculate the fuel requirements for interplanetary travel based on mass and gravitational acceleration.
  """

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

  @doc """
  Calculates the total fuel required for a landing, accounting for the weight
  of the fuel itself. Recursively adds fuel for each fuel load until no
  additional fuel is needed.

  ## Examples

      iex> InterplanetaryTravel.LaunchPlan.FuelCalculator.total_landing_fuel(28_801, 9.807)
      13447
  """
  @spec total_landing_fuel(integer(), float()) :: integer()
  def total_landing_fuel(mass, gravity), do: accumulate_fuel(&landing/2, mass, gravity, 0)

  @doc """
  Calculates the total fuel required for a launch, accounting for the weight
  of the fuel itself. Recursively adds fuel for each fuel load until no
  additional fuel is needed.

  ## Examples

      iex> InterplanetaryTravel.LaunchPlan.FuelCalculator.total_launch_fuel(28_801, 9.807)
      19772
  """
  @spec total_launch_fuel(integer(), float()) :: integer()
  def total_launch_fuel(mass, gravity), do: accumulate_fuel(&launch/2, mass, gravity, 0)

  defp accumulate_fuel(fuel_fn, mass, gravity, acc) do
    case fuel_fn.(mass, gravity) do
      fuel when fuel <= 0 -> acc
      fuel -> accumulate_fuel(fuel_fn, fuel, gravity, acc + fuel)
    end
  end

  defp calculate_fuel(mass, gravity, factor, offset) do
    mass
    |> Kernel.*(gravity)
    |> Kernel.*(factor)
    |> Kernel.-(offset)
    |> Float.floor()
    |> trunc()
  end
end
