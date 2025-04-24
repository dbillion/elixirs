defmodule Coolapp.Repo do
  use Ecto.Repo,
    otp_app: :coolapp,
    adapter: Ecto.Adapters.Postgres
end
