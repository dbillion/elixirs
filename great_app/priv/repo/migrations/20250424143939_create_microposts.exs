defmodule GreatApp.Repo.Migrations.CreateMicroposts do
  use Ecto.Migration

  def change do
    create table(:microposts) do
      add :content, :text
      add :user_id, :integer

      timestamps()
    end
  end
end
