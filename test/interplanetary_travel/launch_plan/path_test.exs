defmodule InterplanetaryTravel.LaunchPlan.PathTest do
  use InterplanetaryTravel.DataCase

  import InterplanetaryTravel.LaunchPlan.Path, only: [changeset: 2]
  alias InterplanetaryTravel.LaunchPlan.Path

  doctest InterplanetaryTravel.LaunchPlan.Path

  describe "changeset/1" do
    test "valid with supported action and planet" do
      attrs = %{action: :launch, planet: :earth}
      assert %{valid?: true, changes: changes} = changeset(%Path{}, attrs)
      assert changes.action == :launch
      assert changes.planet == :earth
    end

    test "invalid with unsupported action" do
      attrs = %{action: :fly, planet: :earth}
      changeset = changeset(%Path{}, attrs)
      assert errors_on(changeset) == %{action: ["is invalid"]}
    end

    test "invalid with unsupported planet" do
      attrs = %{action: :launch, planet: :pluto}
      changeset = changeset(%Path{}, attrs)

      assert errors_on(changeset) == %{planet: ["is invalid"]}
    end

    test "invalid when action is missing" do
      attrs = %{planet: :earth}
      changeset = changeset(%Path{}, attrs)
      assert errors_on(changeset) == %{action: ["can't be blank"]}
    end

    test "invalid when planet is missing" do
      attrs = %{action: :launch}
      changeset = changeset(%Path{}, attrs)
      assert errors_on(changeset) == %{planet: ["can't be blank"]}
    end
  end
end
