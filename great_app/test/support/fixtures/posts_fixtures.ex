defmodule GreatApp.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GreatApp.Posts` context.
  """

  @doc """
  Generate a micropost.
  """
  def micropost_fixture(attrs \\ %{}) do
    {:ok, micropost} =
      attrs
      |> Enum.into(%{
        content: "some content",
        user_id: 42
      })
      |> GreatApp.Posts.create_micropost()

    micropost
  end
end
