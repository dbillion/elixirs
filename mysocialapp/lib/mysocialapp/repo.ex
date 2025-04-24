defmodule Mysocialapp.Repo do
  use Ecto.Repo,
    otp_app: :mysocialapp,
    adapter: Ecto.Adapters.Postgres
end
