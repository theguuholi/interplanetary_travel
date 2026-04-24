defmodule InterplanetaryTravel.LaunchPlanTest do
  use InterplanetaryTravel.DataCase

  import InterplanetaryTravel.LaunchPlan,
    only: [launch: 2, landing: 2]

  doctest InterplanetaryTravel.LaunchPlan

  describe "launch/2" do
    test "given mass and planet, when planet is not available, then return error" do
      assert {:error, :planet_is_not_available} = launch(28_801, :pluto)
    end

    test "given mass and planet, when planet is available, then return fuel required for launch" do
      assert {:ok, 19_772} = launch(28_801, :earth)
    end
  end

  describe "landing/2" do
    test "given mass and planet, when planet is not available, then return error" do
      assert {:error, :planet_is_not_available} = landing(28_801, :pluto)
    end

    test "given mass and planet, when planet is available, then return fuel required for landing" do
      assert {:ok, 13_447} = landing(28_801, :earth)
    end
  end
end
