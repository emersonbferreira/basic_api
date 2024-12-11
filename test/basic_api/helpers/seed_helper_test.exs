defmodule BasicApi.Helpers.SeedHelperTest do
  use ExUnit.Case, async: true
  use BasicApi.DataCase
  import Ecto.Query

  alias BasicApi.Helpers.SeedHelper
  alias BasicApi.Repo
  alias BasicApi.Models.{User, Camera}

  describe "create_users/0" do
    test "create 1000 users" do
      assert Repo.aggregate(User, :count, :id) == 0

      SeedHelper.create_users()

      assert Repo.aggregate(User, :count, :id) == 1000
    end
  end

  describe "create_cameras_for_users/0" do
    setup do
      user = %User{name: "Test User", email: "test@example.com", enabled: true, password_hash: "test"} |> Repo.insert!()
      {:ok, user: user}
    end

    test "create cameras for all user" do
      assert Repo.aggregate(Camera, :count, :id) == 0

      SeedHelper.create_cameras_for_users()

      assert Repo.aggregate(Camera, :count, :id) == 50
    end

    test "has at last one camera for active user", %{user: user} do
      SeedHelper.create_cameras_for_users()

      active_cameras = Repo.all(from c in Camera, where: c.user_id == ^user.id and c.enabled == true)
      assert length(active_cameras) > 0
    end
  end
end
