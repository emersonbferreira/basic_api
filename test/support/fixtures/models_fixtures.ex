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
        email: "some email",
        enabled: true,
        name: "some name",
        password_hash: "some password_hash"
      })
      |> BasicApi.Models.create_user()

    user
  end

  @doc """
  Generate a camera.
  """
  def camera_fixture(attrs \\ %{}) do
    {:ok, camera} =
      attrs
      |> Enum.into(%{
        brand: "some brand",
        desabled_at: nil,
        enabled: true,
        name: "some name"
      })
      |> BasicApi.Models.create_camera()

    camera
  end
end
