defmodule GreatApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias GreatApp.Posts.Micropost

  schema "users" do
    field :email, :string
    field :name, :string
    has_many :microposts, Micropost

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
