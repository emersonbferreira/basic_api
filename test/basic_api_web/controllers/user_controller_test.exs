defmodule BasicApiWeb.UserControllerTest do
  use BasicApiWeb.ConnCase

  import BasicApi.ModelsFixtures

  alias BasicApi.Models.User
  alias BasicApi.Repo

  @create_attrs %{
    enabled: true,
    name: "some name",
    email: "some@email",
    password: "password"
  }
  @invalid_attrs %{enabled: nil, name: nil, email: nil, password_hash: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/users", user: @create_attrs)
      %User{id: user_id} = Repo.all(User) |> List.last()

      assert %{
         "id" => ^user_id,
         "email" => "some@email",
         "enabled" => true,
         "name" => "some name"
        } = json_response(conn, 201)["user"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
