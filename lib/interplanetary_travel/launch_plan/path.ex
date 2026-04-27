defmodule InterplanetaryTravel.LaunchPlan.Path do
  @moduledoc """
  Embedded schema representing a single step in a flight path.
  """

  use Ecto.Schema
  import Ecto.Changeset
  @planets ~w[earth moon mars]a
  @actions ~w[launch land]a
  @fields ~w[action planet]a

  @type action :: :launch | :land | nil
  @type planet :: :earth | :moon | :mars | nil
  @type t :: %__MODULE__{
          action: action(),
          planet: planet()
        }

  embedded_schema do
    field :action, Ecto.Enum, values: @actions
    field :planet, Ecto.Enum, values: @planets
  end

  @doc """
  Returns a changeset for a Path based on the given attributes.
  """
  @spec changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t()
  def changeset(path, attrs) do
    path
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> put_new_id()
  end

  defp put_new_id(changeset) do
    case get_field(changeset, :id) do
      nil -> put_change(changeset, :id, Ecto.UUID.generate())
      _ -> changeset
    end
  end
end
