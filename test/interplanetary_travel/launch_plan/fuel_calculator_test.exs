defmodule InterplanetaryTravel.LaunchPlan.FuelCalculatorTest do
  use InterplanetaryTravel.DataCase

  import InterplanetaryTravel.LaunchPlan.FuelCalculator,
    only: [launch: 2, landing: 2, total_landing_fuel: 2, total_launch_fuel: 2]

  doctest InterplanetaryTravel.LaunchPlan.FuelCalculator

  describe "launch/2" do
    test "given a mass and gravity, when calculate launch fuel, then return the value rounded down" do
      assert launch(28_801, 9.807) == 11_829
    end
  end

  describe "landing/2" do
    test "given a mass and gravity, when calculate landing fuel, then return the value rounded down" do
      assert landing(28_801, 9.807) == 9_278
    end
  end

  describe "total_landing_fuel/2" do
    test "given a mass and gravity, when calculate total landing fuel, then recursively account for fuel weight" do
      assert total_landing_fuel(28_801, 9.807) == 13_447
    end
  end

  describe "total_launch_fuel/2" do
    test "given a mass and gravity, when calculate total launch fuel, then recursively account for fuel weight" do
      assert total_launch_fuel(28_801, 9.807) == 19_772
    end
  end
end
