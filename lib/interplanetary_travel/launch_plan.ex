defmodule InterplanetaryTravel.LaunchPlan do
  @moduledoc """
  High-level API for building and validating interplanetary launch plans.

  This module acts as a boundary around `Plan`, providing:

  - Changeset generation (`change_plan/2`)
  - Validation + computed result (`validate/2`)

  It is designed to be used by interfaces such as LiveView forms.
  """

  import Ecto.Changeset, only: [apply_changes: 1]

  alias InterplanetaryTravel.LaunchPlan.Plan

  @type attrs :: map()
  @type changeset :: Ecto.Changeset.t()
  @type result :: Plan.t()

  @doc """
  Builds a changeset for a launch plan.

  This function does not apply changes; it only prepares validation and casting.

  ## Example

      iex> alias InterplanetaryTravel.LaunchPlan
      iex> alias InterplanetaryTravel.LaunchPlan.Plan

      iex> cs = LaunchPlan.change_plan(%Plan{}, %{mass: 100})
      iex> is_map(cs.changes)
      true
  """
  @spec change_plan(Plan.t(), attrs()) :: changeset()
  def change_plan(plan, attrs \\ %{}) do
    plan
    |> Plan.changeset(attrs)
    |> Map.put(:action, :validate)
  end

  @doc """
  Validates a launch plan and returns both the changeset and the computed result.

  This is useful for LiveView forms where you want:

  - validation errors
  - computed values (like `total_fuel_required`) at the same time

  ## Returns

    `{changeset, result}`

  - `changeset` — includes validation errors
  - `result` — struct with applied changes (even if invalid)

  ## Examples

      iex> alias InterplanetaryTravel.LaunchPlan
      iex> alias InterplanetaryTravel.LaunchPlan.Plan

      iex> attrs = %{mass: 100, paths: [%{action: :launch, planet: :earth}]}
      iex> {cs, plan} = LaunchPlan.validate(%Plan{}, attrs)
      iex> cs.valid?
      true
      iex> is_integer(plan.total_fuel_required)
      true

      iex> {_cs, plan} = LaunchPlan.validate(%Plan{}, %{mass: -1})
      iex> plan.mass == -1
      true
  """
  @spec validate(Plan.t(), attrs()) :: {changeset(), result()}
  def validate(plan, attrs) do
    changeset = change_plan(plan, attrs)
    {changeset, apply_changes(changeset)}
  end
end
