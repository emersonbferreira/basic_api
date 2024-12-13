defmodule BasicApiWeb.UserControllerTest do
  use BasicApiWeb.ConnCase

  import BasicApi.ModelsFixtures

  alias BasicApi.Models.User

  @create_attrs %{
    enabled: true,
    name: "some name",
    email: "some email",
    password_hash: "some password_hash"
  }
  @invalid_attrs %{enabled: nil, name: nil, email: nil, password_hash: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "enabled" => true,
               "name" => "some name",
               "password_hash" => "some password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end


  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
