defmodule BasicApiWeb.CameraControllerTest do
  use BasicApiWeb.ConnCase

  import BasicApi.ModelsFixtures

  alias BasicApi.Models.Camera

  @create_attrs %{
    enabled: true,
    name: "some name",
    brand: "some brand",
    desabled_at: ~N[2024-12-09 17:19:00]
  }
  @update_attrs %{
    enabled: false,
    name: "some updated name",
    brand: "some updated brand",
    desabled_at: ~N[2024-12-10 17:19:00]
  }
  @invalid_attrs %{enabled: nil, name: nil, brand: nil, desabled_at: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all cameras", %{conn: conn} do
      conn = get(conn, ~p"/api/cameras")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create camera" do
    test "renders camera when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/cameras", camera: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/cameras/#{id}")

      assert %{
               "id" => ^id,
               "brand" => "some brand",
               "desabled_at" => "2024-12-09T17:19:00",
               "enabled" => true,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/cameras", camera: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update camera" do
    setup [:create_camera]

    test "renders camera when data is valid", %{conn: conn, camera: %Camera{id: id} = camera} do
      conn = put(conn, ~p"/api/cameras/#{camera}", camera: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/cameras/#{id}")

      assert %{
               "id" => ^id,
               "brand" => "some updated brand",
               "desabled_at" => "2024-12-10T17:19:00",
               "enabled" => false,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, camera: camera} do
      conn = put(conn, ~p"/api/cameras/#{camera}", camera: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete camera" do
    setup [:create_camera]

    test "deletes chosen camera", %{conn: conn, camera: camera} do
      conn = delete(conn, ~p"/api/cameras/#{camera}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/cameras/#{camera}")
      end
    end
  end

  defp create_camera(_) do
    camera = camera_fixture()
    %{camera: camera}
  end
end
