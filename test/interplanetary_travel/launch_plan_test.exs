defmodule InterplanetaryTravel.LaunchPlanTest do
  use InterplanetaryTravel.DataCase

  alias InterplanetaryTravel.LaunchPlan
  alias InterplanetaryTravel.LaunchPlan.Plan

  doctest LaunchPlan

  describe "change_plan/2" do
    test "returns a changeset" do
      changeset = LaunchPlan.change_plan(%Plan{}, %{mass: 100})
      assert %Ecto.Changeset{} = changeset
    end
  end

  describe "validate/2" do
    test "returns changeset and applied result when valid" do
      attrs = %{
        mass: 28_801,
        paths: [
          %{action: :launch, planet: :earth},
          %{action: :land, planet: :moon},
          %{action: :launch, planet: :moon},
          %{action: :land, planet: :earth}
        ]
      }

      {changeset, result} = LaunchPlan.validate(%Plan{}, attrs)

      assert changeset.valid?
      assert result.total_fuel_required == 51_898
    end

    test "returns invalid changeset but still applies partial result" do
      attrs = %{mass: -1, paths: []}

      {changeset, result} = LaunchPlan.validate(%Plan{}, attrs)

      refute changeset.valid?
      assert result.mass == -1
    end

    test "handles empty attrs" do
      {changeset, result} = LaunchPlan.validate(%Plan{}, %{})

      refute changeset.valid?
      assert result.total_fuel_required == 0
    end
  end
end
