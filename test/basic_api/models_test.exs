defmodule BasicApi.ModelsTest do
  use BasicApi.DataCase

  alias BasicApi.Models

  describe "users" do
    alias BasicApi.Models.User

    @invalid_attrs %{enabled: nil, name: nil, email: nil, password_hash: nil}

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{enabled: true, name: "some name", email: "some@email", password: "some password"}

      assert {:ok, %User{} = user} = Models.create_user(valid_attrs)
      assert user.enabled == true
      assert user.name == "some name"
      assert user.email == "some@email"
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Models.create_user(@invalid_attrs)
    end
  end
end
