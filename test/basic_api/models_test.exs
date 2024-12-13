defmodule BasicApi.ModelsTest do
  use BasicApi.DataCase

  alias BasicApi.Models

  describe "users" do
    alias BasicApi.Models.User

    import BasicApi.ModelsFixtures

    @invalid_attrs %{enabled: nil, name: nil, email: nil, password_hash: nil}

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{enabled: true, name: "some name", email: "some email", password_hash: "some password_hash"}

      assert {:ok, %User{} = user} = Models.create_user(valid_attrs)
      assert user.enabled == true
      assert user.name == "some name"
      assert user.email == "some email"
      assert user.password_hash == "some password_hash"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Models.create_user(@invalid_attrs)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Models.change_user(user)
    end
  end
end
