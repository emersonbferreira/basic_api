defmodule BasicApi.ModelsTest do
  use BasicApi.DataCase

  alias BasicApi.Models

  describe "users" do
    alias BasicApi.Models.User

    import BasicApi.ModelsFixtures

    @invalid_attrs %{enabled: nil, name: nil, email: nil, password_hash: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Models.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Models.get_user!(user.id) == user
    end

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

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{enabled: false, name: "some updated name", email: "some updated email", password_hash: "some updated password_hash"}

      assert {:ok, %User{} = user} = Models.update_user(user, update_attrs)
      assert user.enabled == false
      assert user.name == "some updated name"
      assert user.email == "some updated email"
      assert user.password_hash == "some updated password_hash"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Models.update_user(user, @invalid_attrs)
      assert user == Models.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Models.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Models.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Models.change_user(user)
    end
  end

  describe "cameras" do
    alias BasicApi.Models.Camera

    import BasicApi.ModelsFixtures

    @invalid_attrs %{enabled: nil, name: nil, brand: nil, desabled_at: nil}

    test "list_cameras/0 returns all cameras" do
      camera = camera_fixture()
      assert Models.list_cameras() == [camera]
    end

    test "get_camera!/1 returns the camera with given id" do
      camera = camera_fixture()
      assert Models.get_camera!(camera.id) == camera
    end

    test "create_camera/1 with valid data creates a camera" do
      valid_attrs = %{enabled: true, name: "some name", brand: "some brand", desabled_at: ~N[2024-12-09 17:19:00]}

      assert {:ok, %Camera{} = camera} = Models.create_camera(valid_attrs)
      assert camera.enabled == true
      assert camera.name == "some name"
      assert camera.brand == "some brand"
      assert camera.desabled_at == ~N[2024-12-09 17:19:00]
    end

    test "create_camera/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Models.create_camera(@invalid_attrs)
    end

    test "update_camera/2 with valid data updates the camera" do
      camera = camera_fixture()
      update_attrs = %{enabled: false, name: "some updated name", brand: "some updated brand", desabled_at: ~N[2024-12-10 17:19:00]}

      assert {:ok, %Camera{} = camera} = Models.update_camera(camera, update_attrs)
      assert camera.enabled == false
      assert camera.name == "some updated name"
      assert camera.brand == "some updated brand"
      assert camera.desabled_at == ~N[2024-12-10 17:19:00]
    end

    test "update_camera/2 with invalid data returns error changeset" do
      camera = camera_fixture()
      assert {:error, %Ecto.Changeset{}} = Models.update_camera(camera, @invalid_attrs)
      assert camera == Models.get_camera!(camera.id)
    end

    test "delete_camera/1 deletes the camera" do
      camera = camera_fixture()
      assert {:ok, %Camera{}} = Models.delete_camera(camera)
      assert_raise Ecto.NoResultsError, fn -> Models.get_camera!(camera.id) end
    end

    test "change_camera/1 returns a camera changeset" do
      camera = camera_fixture()
      assert %Ecto.Changeset{} = Models.change_camera(camera)
    end
  end
end
