defmodule InterplanetaryTravel.Repo do
  use Ecto.Repo,
    otp_app: :interplanetary_travel,
    adapter: Ecto.Adapters.Postgres
end
