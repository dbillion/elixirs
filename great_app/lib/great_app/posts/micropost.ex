defmodule GreatApp.Posts.Micropost do
  use Ecto.Schema
  import Ecto.Changeset
  alias GreatApp.Accounts.User

  schema "microposts" do
    field :content, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(micropost, attrs) do
    micropost
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
    |> validate_length(:content, max: 280)
  end
end
