defmodule InterplanetaryTravel.LaunchPlan.FuelCalculatorTest do
  use InterplanetaryTravel.DataCase

  import InterplanetaryTravel.LaunchPlan.FuelCalculator,
    only: [launch: 2, landing: 2, calculate: 3]

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

  describe "calculate/3" do
    test "given an action, mass and gravity, when calculate fuel, then return the total fuel required for the action" do
      assert calculate(:launch, 28_801, 9.807) == 19_772
      assert calculate(:land, 28_801, 9.807) == 13_447
    end

    test "given an unsupported action, mass and gravity, when calculate fuel, then return 0" do
      assert calculate(:fly, 28_801, 9.807) == 0
    end
  end
end
