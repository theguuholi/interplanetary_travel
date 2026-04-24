defmodule InterplanetaryTravel.LaunchPlan.PlanTest do
  use InterplanetaryTravel.DataCase

  alias InterplanetaryTravel.LaunchPlan.Plan

  doctest InterplanetaryTravel.LaunchPlan.Plan

  describe "changeset/2" do
    test "valid with positive mass and valid paths" do
      attrs = %{mass: 28_801, paths: [%{action: :launch, planet: :earth}]}
      assert %{valid?: true} = Plan.changeset(%Plan{}, attrs)
    end

    test "invalid when mass is missing" do
      changeset = Plan.changeset(%Plan{}, %{paths: []})
      assert %{valid?: false} = changeset
      assert Keyword.has_key?(changeset.errors, :mass)
    end

    test "invalid when mass is zero" do
      changeset = Plan.changeset(%Plan{}, %{mass: 0, paths: []})
      assert %{valid?: false} = changeset
      assert Keyword.has_key?(changeset.errors, :mass)
    end

    test "invalid when mass is negative" do
      changeset = Plan.changeset(%Plan{}, %{mass: -1, paths: []})
      assert %{valid?: false} = changeset
      assert Keyword.has_key?(changeset.errors, :mass)
    end

    test "invalid when path has unsupported action" do
      attrs = %{mass: 100, paths: [%{action: :fly, planet: :earth}]}
      assert %{valid?: false} = Plan.changeset(%Plan{}, attrs)
    end

    test "invalid when path has unsupported planet" do
      attrs = %{mass: 100, paths: [%{action: :launch, planet: :pluto}]}
      assert %{valid?: false} = Plan.changeset(%Plan{}, attrs)
    end

    test "valid with multiple paths and all planets" do
      attrs = %{
        mass: 500,
        paths: [
          %{action: :launch, planet: :earth},
          %{action: :land, planet: :moon},
          %{action: :launch, planet: :moon},
          %{action: :land, planet: :mars}
        ]
      }

      assert %{valid?: true} = Plan.changeset(%Plan{}, attrs)
    end

    test "Apollo 11 Mission: launch Earth, land Moon, launch Moon, land Earth" do
      attrs = %{
        mass: 28_801,
        paths: [
          %{action: :launch, planet: :earth},
          %{action: :land, planet: :moon},
          %{action: :launch, planet: :moon},
          %{action: :land, planet: :earth}
        ]
      }

      assert %{valid?: true, changes: changes} = Plan.changeset(%Plan{}, attrs)
      assert changes.total_fuel_required == 51_898
    end

    test "Passenger Ship Mission: launch Earth, land Moon, launch Moon, land Mars, launch Mars, land Earth" do
      attrs = %{
        mass: 75_432,
        paths: [
          %{action: :launch, planet: :earth},
          %{action: :land, planet: :moon},
          %{action: :launch, planet: :moon},
          %{action: :land, planet: :mars},
          %{action: :launch, planet: :mars},
          %{action: :land, planet: :earth}
        ]
      }

      assert %{valid?: true, changes: changes} = Plan.changeset(%Plan{}, attrs)
      assert changes.total_fuel_required == 212_161
    end

    test "Mars Mission: launch Earth, land Mars, launch Mars, land Earth" do
      attrs = %{
        mass: 14_606,
        paths: [
          %{action: :launch, planet: :earth},
          %{action: :land, planet: :mars},
          %{action: :launch, planet: :mars},
          %{action: :land, planet: :earth}
        ]
      }

      assert %{valid?: true, changes: changes} = Plan.changeset(%Plan{}, attrs)
      assert changes.total_fuel_required == 33_388
    end
  end
end
