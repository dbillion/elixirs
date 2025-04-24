defmodule GreatApp.Repo do
  use Ecto.Repo,
    otp_app: :great_app,
    adapter: Ecto.Adapters.Postgres
end
