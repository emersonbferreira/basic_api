defmodule BasicApi.ModelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BasicApi.Models` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some@email",
        enabled: true,
        name: "some name",
        password: "some password"
      })
      |> BasicApi.Models.create_user()

    user
  end
end
