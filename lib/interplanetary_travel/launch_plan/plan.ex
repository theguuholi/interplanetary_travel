defmodule InterplanetaryTravel.LaunchPlan.Plan do
  @moduledoc """
  Embedded schema representing a flight plan with a spacecraft mass and a list of path steps.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias InterplanetaryTravel.LaunchPlan.FuelCalculator
  alias InterplanetaryTravel.LaunchPlan.Path

  @available_planets %{
    earth: 9.807,
    moon: 1.62,
    mars: 3.711
  }

  @fields ~w/total_fuel_required/a
  @required_fields ~w/mass/a

  @type t :: %__MODULE__{
          mass: integer() | nil,
          total_fuel_required: integer(),
          paths: [Path.t()]
        }

  embedded_schema do
    field :mass, :integer
    field :total_fuel_required, :integer, default: 0
    embeds_many :paths, Path, on_replace: :delete
  end

  @doc """
  Returns a changeset for a Plan based on the given attributes.
  It will return the calculated total fuel required for the plan based on the mass and paths provided.
  """
  @spec changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t()
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, @fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:mass, greater_than: 0)
    |> cast_embed(:paths,
      with: &Path.changeset/2,
      sort_param: :paths_sort,
      drop_param: :paths_drop
    )
    |> add_total_fuel_required()
  end

  defp add_total_fuel_required(changeset) do
    paths = get_field(changeset, :paths, [])
    equipment_mass = get_field(changeset, :mass, 0)

    {_, total_fuel_required} =
      paths
      |> Enum.reverse()
      |> Enum.reduce({equipment_mass, 0}, &add_fuel/2)

    put_change(changeset, :total_fuel_required, total_fuel_required)
  end

  defp add_fuel(%{action: action, planet: planet}, {mass, fuel_acc}) do
    gravity = Map.get(@available_planets, planet, 0)

    step_fuel = FuelCalculator.calculate(action, mass, gravity)

    {mass + step_fuel, fuel_acc + step_fuel}
  end
end
