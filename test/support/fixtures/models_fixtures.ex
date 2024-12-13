defmodule BasicApi.ModelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BasicApi.Models` context.
  """
  alias BasicApi.Models.Camera
  alias BasicApi.Repo

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

  @doc """
  Generate a camera.
  """
  def camera_fixture(user, attrs \\ %{}) do
    camera_attrs =
      attrs
      |> Enum.into(%{
        brand: "Hikvision",
        enabled: true,
        user_id: user.id,
        name: "some camera"
      })

    {:ok, camera} = %Camera{}
    |> Camera.changeset(camera_attrs)
    |> Repo.insert()

    camera
  end
end
